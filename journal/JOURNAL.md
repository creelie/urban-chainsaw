# Target journal: Discrete Mathematics

| Item | Details |
|---|---|
| Journal | Discrete Mathematics |
| Publisher | Elsevier |
| ISSN | 0012-365X (print) |
| Homepage | https://www.sciencedirect.com/journal/discrete-mathematics |
| Submission | "Submit your article" on the homepage, which opens the journal's Editorial Manager site, https://www.editorialmanager.com/disc/ |
| Template | Elsevier `elsarticle` class (included as `paper/elsarticle.cls`), `preprint,12pt` option, numbered references with `elsarticle-num.bst` |

## Scope fit

Elsevier describes the journal as "a common forum for significant research in
many areas of discrete mathematics and combinatorics", publishing research
articles as Contributions or Notes depending on length. The paper answers part
(b) of Problem 20.71 of the Kourovka Notebook (J. Lauri), a question on
vertex-deleted subgraphs and automorphism orbits of graphs, with a Cayley graph
of a Suzuki 2-group and a proof by hand. At 9 pages it fits the journal as a
short Contribution or a Note. Ars Mathematica Contemporanea (graph symmetry,
open access) and the Journal of Graph Theory are alternatives.

## Length and format

- The manuscript is 9 pages in the `elsarticle` preprint layout (12 pt, single
  column).
- Elsevier accepts a first submission as a single PDF; after acceptance the
  LaTeX source, the class file and the `.bib` or `.bbl` file are uploaded. The
  arXiv tarball in `dist/` contains exactly these files.
- Required front matter, all present: title, author with address and email,
  abstract, keywords, MSC 2020 codes (05C60, 05C25, 20D15, 68V15).
- Check the guide for authors on the journal homepage for any page or abstract
  limit before submitting.
- Editorial Manager asks at submission for a declaration of competing
  interests and for funding information; these are filled in by the author on
  the submission form.

## Policy on AI assistance (Elsevier generative AI policy for journals)

- AI tools may not be listed as authors or cited as authors.
- Use of AI tools in manuscript preparation is disclosed in a separate section
  titled "Declaration of generative AI and AI-assisted technologies in the
  manuscript preparation process", placed before the references; the statement
  appears in the published article. Elsevier's recommended wording is used in
  `paper/main.tex`.
- Use of AI tools in the research process is described in the methods part of
  the paper; Section 5 (Formal verification and computations) states it.
- The authors remain responsible for checking all AI-generated output,
  including references. The DOIs in `paper/refs.bib` were checked against
  their Crossref records (Higman, Haemers-Kharaghani-Meulenberg, McKay-Piperno)
  and the problem text against arXiv:1401.0300v48.
- Source: https://www.elsevier.com/about/policies-and-standards/generative-ai-policies-for-journals
