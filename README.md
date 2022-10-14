# PHES-ODM-Doc

Repository for documentation to support use and uptake of the Public Health Environmental Surveillance Open Data Model (PHES-ODM).

# Repo Organization and Usage

This repo uses [quarto](https://quarto.org/) for its documentation purposes. All quarto files should be in the [qmd](./qmd) directory. The [quarto configuration file](./qmd/_quarto.yml) is also in there. The following commands can be used to build the documentation:

* When working on the documentation you can run the command `quarto preview ./qmd` in the terminal to get a live preview of your changes everytime you make a change
* When building the documentation for publishing purposes, you can run the command `quarto render ./qmd`.

All the built files are in the [docs](./docs) folder. **This folder should only be changed and committed when publishing a new version of the documentation**.

## Repo Standards

* Use [kebab-case](https://www.theserverside.com/definition/Kebab-case#:~:text=Kebab%20case%20%2D%2D%20or%20kebab,properly%20convey%20a%20resource's%20meaning.) when naming files and folder making sure to use lower case