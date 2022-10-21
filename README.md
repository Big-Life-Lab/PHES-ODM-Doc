# PHES-ODM-Doc

Repository for documentation to support use and uptake of the Public Health Environmental Surveillance Open Data Model (PHES-ODM).

# Repo Organization and Usage

This repo uses [quarto](https://quarto.org/) for its documentation purposes. All quarto files should be in the [qmd](./qmd) directory. The [quarto configuration file](./qmd/_quarto.yml) is also in there. The following commands can be used to build the documentation:

* When working on the documentation you can run the command `quarto preview ./qmd` in the terminal to get a live preview of your changes everytime you make a change
* When building the documentation for publishing purposes, you can run the command `quarto render ./qmd`.

All the built files are in the [docs](./docs) folder. **This folder should only be changed and committed when publishing a new version of the documentation, do not commit or add this folder to any branch other than docs**. Once built the docs folder contains the website as well as the built PDF.

# Repo Standards

## Naming Conventions

* Use [kebab-case](https://www.theserverside.com/definition/Kebab-case#:~:text=Kebab%20case%20%2D%2D%20or%20kebab,properly%20convey%20a%20resource's%20meaning.) when naming files and folder making sure to use lower case

## File Organization

* All assets (images, gifs etc.) should go in the [assets](./assets) folder. Follow the naming convention as above for files and folder.

## Git Workflow

* The main branch (master or main) should always have the latest public/working/correct/buildable version of the documentation
* All PRs should be made to the dev branch which has the next version of the documentation. When the dev branch is ready to be made public, it should be merged into master.
* When a new version is released, the commit that has the new version should be tagged with the version number