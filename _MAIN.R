
# ---- *** COVID Recovery Dashboard *** ----
# https://ec.europa.eu/eurostat/cache/recovery-dashboard/

update.input=TRUE # update input data files (estat, ameco, silc)? TRUE/FALSE
dashboard=TRUE # generate dashboard? TRUE/FALSE


# ---- START ----
source("./OUTILS/CONFIG/SETUP.R")

# ---- DATA ----
if (update.input) source("./OUTILS/FUNS/DATA.R")

# ---- OUTPUT ----
if (update.input | dashboard) {
  rmarkdown::render(here("OUTILS","BLOX","REPORT.Rmd"),
                    output_file="European Statistical Recovery Dashboard.html",
                    output_dir=here("OUTPUT"),
                    intermediates_dir=here("T E M P"),
                    quiet=TRUE,
                    clean=TRUE)
  }
