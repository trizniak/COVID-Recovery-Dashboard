
# ---- *** COVID Recovery Dashboard *** ----
# https://ec.europa.eu/eurostat/cache/recovery-dashboard/

update.input=TRUE # update input data files (estat, ameco, silc)? TRUE/FALSE
dashboard=TRUE # generate dashboard? TRUE/FALSE


# ~~~ RUN : START ~~~ ####
run.start=Sys.time()

# ---- START ----
.connect2internet("OrizaT");.connect2internet("OrizaT")
source("./OUTILS/CONFIG/SETUP.R")
sapply(c("./DATA",
         "./OUTPUT",
         "./T E M P"),
         dir.create)
  # pandemic start : 15 March 2020
  # https://ec.europa.eu/info/live-work-travel-eu/coronavirus-response/timeline-eu-action_en
  # https://en.wikipedia.org/wiki/COVID-19_pandemic_in_Europe
start.pandemic=lubridate::ymd("2020-03-15")

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


# ~~~ RUN : END ~~~ ####
cat(paste0("RUNTIME : ",
           lubridate::int_diff(c(run.start,
                                 Sys.time())) %>%
             lubridate::int_length() %>%
             round() %>%
             lubridate::seconds_to_period(),
           "\n\n"))