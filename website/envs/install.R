#!/usr/bin/env R

# disable if rocker image is used
# see https://packagemanager.posit.co/client/#/repos/cran/setup
# options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/2023-04-20"))

install.packages("JuliaCall")
install.packages("reticulate")
install.packages("rmarkdown")
install.packages("knitr")
