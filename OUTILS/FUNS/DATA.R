
# ---- DATA ----

# AUX FUN ----

F.data.estat = function (datafile,
                         lag=0) {
  get_eurostat(datafile,
               time_format="raw",
               keepFlags=TRUE) %>%
    rename(COUNTRY=geo,
           val=values) %>%
    mutate(YEAR=as.numeric(substr(time,1,4))-lag,
           QUARTER=as.numeric(ifelse(str_detect(time,"Q"),
                                     substr(time,6,6),0)),
           MONTH=as.numeric(ifelse(str_detect(time,"M"),
                                   substr(time,6,7),0)),
           WEEK=0,
           freq=ifelse(nchar(time)==4,"Y",
                       substr(time,5,5)),
           d.break=ifelse(substr(flags,1,1)=="b",1,NA),
           COUNTRY=as.character(COUNTRY),
           dataset=paste0("https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=",
                          datafile)) %>%
    filter(COUNTRY %in% c("EU27_2020",
                          names(country.list)),
           YEAR>=2005,
           !is.na(val)) %>%
    mutate(COUNTRY=recode(COUNTRY,
                          EU27_2020="EU"))
}

F.labels.estat = function (datafile) {
  restatapi::get_eurostat_dsd(datafile) %>%
    data_frame() %>%
    mutate(dataset=datafile,
           title=eurostat::label_eurostat_tables(datafile),
           n=which(estat.datasets==datafile)) %>%
    rename_all(toupper) %>%
    filter(!(CONCEPT %in% c("GEO","FREQ") |
               str_detect(CONCEPT,"OBS_")))
}


# AUX PARAM ----
select.vars=c("dataset",
              "section",
              "COUNTRY",
              "YEAR",
              "QUARTER",
              "MONTH",
              "WEEK",
              "INDICATOR",
              "item",
              "freq",
              "val",
              "unit")


# DATA ----

data.CRD = bind_rows(
  utils::read.csv("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv") %>%
    rename(COUNTRY=1) %>%
    separate(year_week,
             into=c("YEAR","WEEK"),
             sep="([[:punct:]])",
             convert=TRUE) %>%
    select(-c(continent,source)) %>%
    mutate(dataset="https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv",
           section="COVID",
           QUARTER=0,
           MONTH=0,
           INDICATOR=indicator,
           item="Weekly_count",
           freq="W",
           val=weekly_count,
           unit="Persons") %>%
    filter(COUNTRY %in% c("EU/EEA (total)",
                          country.list)) %>%
    mutate(COUNTRY=ifelse(COUNTRY=="EU/EEA (total)","EU",
                          names(country.list)[grep(COUNTRY,country.list,
                                                   fixed=TRUE)])) %>%
    select(all_of(select.vars)),
  F.data.estat("ei_bssi_m_r2") %>%
    filter(indic=="BS-ESI-I",
           s_adj=="SA") %>%
    mutate(section="ECONOMY",
           INDICATOR="ESI",
           item=indic,
           unit="score") %>%
    select(all_of(select.vars)),
  F.data.estat("namq_10_gdp") %>%
    filter(na_item=="B1G",
           unit=="CP_MEUR",
           s_adj=="SCA") %>%
    mutate(section="ECONOMY",
           INDICATOR="GDP",
           item=na_item,
           val=val/1000,
           unit=="CP_BEUR") %>%
    select(all_of(select.vars)),
  F.data.estat("prc_hicp_manr") %>%
    filter(coicop=="CP00") %>%
    mutate(section="ECONOMY",
           INDICATOR="CPI",
           item=coicop,
           unit="PCT") %>%
    select(all_of(select.vars)),
  F.data.estat("une_rt_m") %>%
    filter(s_adj=="SA",
           age=="TOTAL",
           sex=="T",
           unit=="PC_ACT") %>%
    mutate(section="ECONOMY",
           INDICATOR="UNE",
           item=NA) %>%
    select(all_of(select.vars)),
  F.data.estat("sts_inpr_m") %>%
    filter(s_adj=="SCA",
           nace_r2=="B-D",
           unit=="I15") %>%
    mutate(section="ECONOMY",
           INDICATOR="IND",
           item=nace_r2) %>%
    select(all_of(select.vars)),
  F.data.estat("sts_setu_q") %>%
    filter(s_adj=="SCA",
           nace_r2=="G-N_STS",
           indic_bt=="TOVT",
           unit=="I15") %>%
    mutate(section="ECONOMY",
           INDICATOR="SRV",
           item=nace_r2) %>%
    select(all_of(select.vars)),
  F.data.estat("sts_trtu_m") %>%
    filter(s_adj=="SCA",
           nace_r2=="G47",
           indic_bt=="TOVT",
           unit=="I15") %>%
    mutate(section="ECONOMY",
           INDICATOR="RET",
           item=nace_r2) %>%
    select(all_of(select.vars)),
  F.data.estat("tour_occ_nim") %>%
    filter(nace_r2=="I551-I553",
           c_resid=="TOTAL",
           unit=="NR") %>%
    mutate(section="ECONOMY",
           INDICATOR="TOU",
           item=nace_r2,
           val=val/1000) %>%
    select(all_of(select.vars))
)

save(data.CRD,file=here("DATA","DATA.Rdata"))
