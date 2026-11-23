# Structure Rules

In this repository, we will focus on keeping a better file structure. Place your file paths and intent here to inform others of locations.

Each folder and file should be seperated by goal, and be named accordingly.
Use camel case for file and folder names unless a local style guide overwrites it.

When working on this project, keep the entire folder open so that you can find your way through, and always check if relevant work has already been made before you make it again.

In any given folder, place everything as follows (mind the (alphabetical) order):

1. Oneline (Folder) docstring
2. Detailed .md primer (if relevant)
3. files.extension
   1. Oneline (File) docstring.
4. subfolders

## File structure:

- projectpart2
  - .gitattributes
  - .gitignore
  - readme.md
    - Primers for the grader and teachers. Assume that the reader is unfamiliar with our work.
  - structure.md
    - A detailed version of the repositories file structure. If you don't know where to find a file or function, or don't know what a file does, check this file first.
  - style.md
    - A collection of style guides for consistency. If you do not follow this file, Casper will complain at you.
  - application/
    - Group Product
    - data/

      - Second or Third party data and research papers.
    - programs/

      - Code
    - reports/

      - Results and deliverables
      - 2-researchquestions.pdf

        - LaTeX writer test -Remove?
      - 2-researchquestions.tex

        - LaTeX test writer -Remove or move to finalreport/
      - finalreport/

        - Final report in LaTeX, devided per chapter.
        - [s]()structuretex/
          - LaTex files for the introductory chapter structure.tex
          - structure.tex
            - A test and introduction to the final report.
  - Legal/
    - Group process
    - AIdoc.xlsx
      - Documentation of AI use. **Every time AI is used, immediatly report it here.**
    - CoopContractG1P5_2.docx
      - Cooperation Contract. **DO NOT FORGET TO SIGN.**
    - plan.md
      - Past, present and future action plan based of weekly meetings.
    - Meetings/
      - Archive of past meetings.
      - Meeting Week1.pptx
        - dummy powerpoint to establish naming convention.
      - Notes Week1.txt
        - See previous file. Not strict or
