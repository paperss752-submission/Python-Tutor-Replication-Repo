# Online Python Tutor: Quantitative results and visualizations

For anonymity of human subjects, raw text data is not included here -- please email the authors at [icse2026.806@gmail.com](icse2026.806@gmail.com). 

The processed data in `annotations-data-analysis/derived-dataframes/` is valid input to the GLMER analysis script in `annotations-data-analysis`.

The long form data in `data-management/data/clean/v7/` is valid input to our counting and data visualization scripts. Outputs are provided in `annotations-data-analysis/output/`.

Full annotation data (before cleaning) is in `data-management/data/v*/`.

## Contents
- `data-management/scripts/data-management_qdpx-to-csv.ipynb` --- script for step 1 of data management/processing
- `data-management/scripts/data-management_csv-cleaning.ipynb` --- script for step 2 of data management/processing
- `data-management/scripts/balanced-f-measure.ipynb` --- script for IRR evaluation
- `data-management/data/` --- data before and after filtering and processing, described above
- `annotations-data-analysis/regression-analysis-data-preprocessing.ipynb` --- script for step 3 of data management/processing
- `annotations-data-analysis/derived-dataframes/regression-data-v5/` --- anonymized version of the dataframes output by data management/processing
- `annotations-data-analysis/glmer-regression-analysis-v3.Rmd` --- script for primary quantitative analysis (GLMER models)
- `annotations-data-analysis/rscripts/` --- for ease of use, individual model fitting steps are copied into short R scripts in this directory
- `annotations-data-analysis/counting-things.ipynb` --- script to generate counting results and data visualization presented in the paper
- `annotations-data-analysis/output/` --- data visualizations presented in the paper

## Usage
We run the GLMER analysis script using [RStudio Server](https://posit.co/download/rstudio-server/). Individual R scripts can be run with just R. 
We run the Python scripts in classic [Jupyter Notebook](https://jupyter.org/install).
