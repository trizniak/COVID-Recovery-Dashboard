
# ---- *** FE Uprating *** ----

update.input=FALSE # update input data files (estat, ameco, silc)? TRUE/FALSE
update.models=FALSE # update models (estimates, forecast, performance)? TRUE/FALSE
report.O=FALSE # generate OVERVIEW report? TRUE/FALSE
report.C=FALSE # generate reports by country? TRUE/FALSE

# ---- START ----
source("./OUTILS/CONFIG/SETUP.R")

# ---- PARAM ----
index.refY=2015 # Reference YEAR for rescaling absolute values as indices
# * Model param ----
core.model="val.silc~val"
generic.predictors=c("`CP00 @ prc_hicp_aind`",
                     "`UVGD @ AMECO`",
                     "`UVGD.pc @ AMECO`")
# * Model types ----
model.lab=c(direct="Direct (estimate = specific predictor)",
            m.lm1="Univariate linear (specific predictor)",
            m.ar1="Univariate linear w/ ARIMA errors (specific predictor)",
            m.lmx="Multivariate linear (specific predictor + generic predictors)",
            m.arx="Multivariate linear w/ ARIMA errors (specific predictor + generic predictors)")

# ---- WORK ----
if (update.input) source("./OUTILS/FUNS/DATA.R")
if (update.models) source("./OUTILS/FUNS/ANALYTICS_MODELING.R")


# ---- OUTPUT ----
{if (update.input | update.models | report.O | report.C)
  source(here("OUTILS","FUNS","OUTPUT.R"))}
