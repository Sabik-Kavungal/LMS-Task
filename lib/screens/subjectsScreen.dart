import 'package:flutter/material.dart';
import 'package:lms/models/subject.dart';
import 'package:lms/screens/ModulesScreen.dart';
import 'package:lms/viewModels/subjectsVM.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectsScreen extends StatelessWidget {
  static const String routeName = '/subjects-screen';
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SubjectsVM()..fetchSubjects(),
      child: Consumer<SubjectsVM>(
        builder: (context, subjectsVM, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Subjects",
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
                subjectsVM.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : subjectsVM.subjects.isEmpty
                    ? Center(
                      child: Text(
                        'No subjects available',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                    : Container(
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: List.generate(
                              subjectsVM.subjects.length,
                              (index) => _CustomSubjectCard(
                                subject: subjectsVM.subjects[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
          );
        },
      ),
    );
  }
}

class _CustomSubjectCard extends StatelessWidget {
  final Subject subject;

  const _CustomSubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      // color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),

      //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pushNamed(
            context,
            ModulesScreen.routeName,
            arguments: subject.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: subject.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (_, __, ___) =>
                          const Icon(Icons.error, size: 40, color: Colors.red),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subject.description,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
