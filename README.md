# Osimertinib Integrated Population Pharmacokinetic Modeling

This repository contains the model files, simulated datasets, and analysis code used for the integrated population pharmacokinetic analysis of osimertinib.

## Repository contents

- `CPP/`: mrgsolve model implementations of the four published source models.
- `modeling/`: NONMEM control files and datasets used for model development and evaluation.
- `R CODE/`: R scripts used for data processing, model evaluation, simulations, and visualization.
- Root directory: Additional analysis datasets and supporting computational files.

## Reproducibility

The repository provides the simulated datasets used in the analysis, allowing the computational results to be evaluated without regenerating the virtual cohorts.

The NONMEM control files and R scripts provide the computational specifications used for model estimation, evaluation, and simulation.

Random seeds are documented where available in the corresponding computational files.

## Data source

The analysis was based on published population pharmacokinetic models and simulated datasets rather than original patient-level observations.
