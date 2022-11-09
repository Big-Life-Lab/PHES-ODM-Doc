# PHES-ODM-Doc

This repository generates the documentation website for Public Health Environmental Surveillance Open Data Model (PHES-ODM). The website is a [quarto book](https://quarto.org/docs/books/) and it can be found [here](https://big-life-lab.github.io/PHES-ODM-Doc/).

The documentation is built here, and then once finalized will be pushed to the website and the official repo for the full ODM project. The documentation built here is intended to follow the Divio approach of a ["The Grand Unified Theory of Documentation"](https://documentation.divio.com). This is comprised of *tutorials*, *how-to guides*, *technical reference*, and *explanation*.

- *Tutorials* are learning-oriented, with a focus on learning through doing. These are less about _what_ is being taught, and more about building confidence and developing skills.

- *How-to Guides* are problem-oriented, with a focus on answering a specific question or problem. 

- *Technical References* are information-oriented, with a focus on providing information on a given topic or piece. This gives an overview of an item, as well as common potential problmes.

- *Explanations* are understanding-oriented and exist neither to teach or describe, but rather to analyse, deepen, and enrich knowledge about a given system. This is not essential reading for users, but is available for users who are interested.

## Rough Outline for PHES-ODM Documentation

This overview is a skeleton, but subjject to change and review as documentation work advances.

### Introduction 
- Representation of wastewater in tables

### Tutorials 
- Using templates 
- Describing methods 
- Describing your program 

### How-To Guides 
- How to use templates:
  * How to report methods: text tutorial with images + narrated video (YouTube)  
  * How to report measures: text tutorial with images + narrated video (YouTube) 
  * How to report samples: text tutorial with images + narrated video (YouTube) 
  * How to report metadata: text tutorial with images + narrated video (YouTube) 
- Example data for each of the 11 report tables. 

### Technical References 
- Automatically generated documentation pieces across sections: 
  * Full parts list 
  * Tables 
  * Measures 
  * Methods 
  * Aggregations 
  * Units 

- The Entity Relationship Diagram (PDF + SQL) 
- List of tools:
  * Validator 
  * PCR analyzer 

### Explanations

- What are part types? 
- Rationale behind sets (why are category sets different)
- Rationale of specimen IDs
- Rationale of Groups and Classes
- Tables and Report table types 
- Measures, methods, and attributes
- Quality and Reportability
- Time periods for samples and measures. 
- Translation and language capabilities 
- Discourse posts ([PHES-ODM Discourse Page](https://odm.discourse.group/))

Repository for documentation to support use and uptake of the Public Health Environmental Surveillance Open Data Model (PHES-ODM).

# Repository Organization and Usage

This repo uses [quarto](https://quarto.org/). All quarto files should be in the [qmd](./qmd) directory. Configuration that specifies how the website is generate is in the [quarto configuration file](./qmd/_quarto.yml).

The following commands can be used to build the documentation:

-   When working on the documentation you can run the command `quarto preview ./qmd` in the terminal to get a live preview of your changes every time you make a change.
-   For publishing, you can run the command `quarto render ./qmd`.

**Do not modify the files in the docs folder yourself.** Quarto renders the website and PDF files to the [docs](./docs) folder.

**You should not commit changes to the docs folder.** The full website is automatically built and generates all the needed files in the docs folder when a PR is merged.

# Repo Standards

## Naming Conventions

-   Use [kebab-case](https://www.theserverside.com/definition/Kebab-case#:~:text=Kebab%20case%20%2D%2D%20or%20kebab,properly%20convey%20a%20resource's%20meaning.) when naming files and folder making sure to use lower case

## File Organization

-   All assets (images, gifs etc.) should go in the [assets](./assets) folder. Follow the naming convention as above for files and folder.

## Git Workflow

-   The main branch (master or main) should always have the latest public/working/correct/buildable version of the documentation
-   All PRs should be made to the dev branch which has the next version of the documentation. When the dev branch is ready to be made public, it should be merged into master.
-   When a new version is released, the commit that has the new version should be tagged with the version number.

# Continuous Integration (CI)

CI is done using github actions. Currently, there are two actions:

1) PR merges trigger a rendering of the website. **The website is not publicly published.**

2) Commits to main trigger a website render, a commit to the `gh-pages` branch, and **an update to the public website** (through the commit to the `gh-pages` branch).

## Setup

-   [build-docs-composite-action.yml](./.github/actions/build-docs-composite-action/action.yml) contains a reusable action to build the docs using quarto
-   [check-pr.yml](./.github/workflows/check-pr.yml) contains the action run when a PR is made and commits pushed to it
-   [publish-docs.yml](./.github/workflows/publish-docs.yml) contains the action run when a push is made to master. The documentation is published to github pages in this action.
