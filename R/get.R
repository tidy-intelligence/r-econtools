
get_population <- function(geographies) {
  wbwdi::wdi_get(geographies = geographies, indicators = "SP.POP.TOTL")
}

get_poverty_ratio <- function(geographies) {
  wbwdi::wdi_get(geographies = geographies, indicators = "SI.POV.DDAY")
}

get_population_density <- function(geographies) {
  wbwdi::wdi_get(geographies = geographies, indicators = "EN.POP.DNST")
}

# get_gdp <- function(geographies, usd = TRUE) {
  # indicator = ifelse(usd, "NGDPD", "NGDP") 
  # imfweo::weo_get(indicator)
# }

# get_gdp <- function(geographies, usd = TRUE) {
  # indicator = "GGX_NGDP"
  # imfweo::weo_get(indicator)
# }