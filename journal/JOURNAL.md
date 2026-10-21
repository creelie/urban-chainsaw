# Target journal: Discrete Mathematics

| Item | Details |
|---|---|
| Journal | Discrete Mathematics |
| Publisher | Elsevier |
| ISSN | 0012-365X (print), confirmed in the Crossref journal record |
| Homepage | https://www.sciencedirect.com/journal/discrete-mathematics |
| Submission | "Submit your article" on the homepage, which opens the journal's Editorial Manager site, https://www.editorialmanager.com/disc/ |
| Template | Elsevier `elsarticle` class (included as `paper/elsarticle.cls`), `preprint,12pt` option, numbered references with `elsarticle-num.bst` |

## Scope fit

Elsevier describes the journal as "a common forum for significant research in
many areas of discrete mathematics and combinatorics", publishing research
articles as Contributions or Notes depending on length. The paper answers part
(b) of Problem 20.71 of the Kourovka Notebook (J. Lauri), a question on
vertex-deleted subgraphs and automorphism orbits of graphs, with a Cayley graph
of a Suzuki 2-group and a proof by hand. At 10 pages it fits the journal as a
short Contribution or a Note. Ars Mathematica Contemporanea (graph symmetry,
open access) and the Journal of Graph Theory are alternatives.

## Length and format

- The manuscript is 10 pages in the `elsarticle` preprint layout (12 pt, single
  column), with three figures.
- Elsevier accepts a first submission as a single PDF; after acceptance the
  LaTeX source and the class file are uploaded. The references are in
  `main.tex` itself (`thebibliography`), so no `.bib` or `.bbl` file is needed;
  the arXiv tarball in `dist/` contains exactly these files.
- Required front matter, all present: title, two authors with addresses,
  emails and ORCID (Deep Bhattacharjee, corresponding author; Ushashi
  Bhattacharya), abstract, keywords, MSC 2020 codes (Primary 05C60; Secondary
  05C25, 20D15, 68V15).
- Check the guide for authors on the journal homepage for any page or abstract
  limit before submitting.
- The paper ends with "Data and code availability" (the GitHub release v2.1.0,
  the
  preprint link and the statement that Deep Bhattacharjee carried out the
  computations and verifications and that the proofs and text were drafted
  with AI assistance from Claude, Anthropic, both authors approving the final
  version) and "Ethical declarations" (funding none, competing interests
  none); Editorial Manager asks for the same declarations on the submission
  form.

## Policy on AI assistance (Elsevier generative AI policy for journals)

- AI tools may not be listed as authors or cited as authors.
- Use of AI tools in manuscript preparation is disclosed in the "Data and
  code availability" section of `paper/main.tex`; if Editorial Manager asks
  for Elsevier's separate "Declaration of generative AI and AI-assisted
  technologies in the manuscript preparation process", give the same statement
  there.
- The authors remain responsible for checking all AI-generated output,
  including references. The DOIs in the bibliography of `paper/main.tex` were checked against
  their Crossref records on 15 October 2026 (Higman, Haemers-Kharaghani-
  Meulenberg, de Moura-Ullrich, the mathlib Community) and on 17 October 2026
  the problem text against arXiv:1401.0300v48,
  and the link to Prajapati's preprint.
- Source: https://www.elsevier.com/about/policies-and-standards/generative-ai-policies-for-journals
- Fee: none on the subscription route; optional open access carries a charge and is not needed.
- The journal version is in `paper/paper1/` (PDF) and `paper/paper2/` (LaTeX source zip), the same files as in `dist/`.
