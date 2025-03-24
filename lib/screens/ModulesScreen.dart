import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms/models/module.dart';
import 'package:lms/screens/VideosScreen.dart';
import 'package:lms/viewModels/modulesVM.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  static const String routeName = '/module-screen';
  final String subjectId;

  const ModulesScreen({super.key, required this.subjectId});

  @override
  // ignore: library_private_types_in_public_api
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Provider.of<ModulesVM>(
      context,
      listen: false,
    ).fetchModules(widget.subjectId);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modulesProvider = Provider.of<ModulesVM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modules",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body:
          modulesProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : modulesProvider.error != null
              ? Center(
                child: Text(
                  'Error: ${modulesProvider.error}',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              )
              : AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      modulesProvider.modules.length,
                      (index) => FadeTransition(
                        opacity: _animationController,
                        child: _ModuleTile(
                          module: modulesProvider.modules[index],
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                VideosScreen.routeName,
                                arguments: modulesProvider.modules[index].id,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final Module module;
  final VoidCallback onTap;

  const _ModuleTile({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        // color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.school, size: 32, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
