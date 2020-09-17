library(reticulate)

conda_create("r-reticulate")

conda_install("r-reticulate", "tensorflow")
conda_install("r-reticulate", "keras")
conda_install("r-reticulate", "numpy")
conda_install("r-reticulate", "pandas")
