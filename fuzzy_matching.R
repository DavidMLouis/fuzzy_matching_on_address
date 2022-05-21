# Author: David M. Louis
# Contact: dmlouis87@gmail.com

##########################################################################
###################### importing data ####################################
##########################################################################
#import data
library(readxl)
library(writexl)
BIG_DOC <- read_excel("/PATH/FILE.xlsx")
DOCUMENT_WITH_MISSING_DATA <- read_excel("/PATH/DOCUMENT_WITH_NAME.xlsx")

##########################################################################
###################### cleaning data #####################################
##########################################################################
#splitting data address data
df1 <- DOCUMENT_WITH_MISSING_DATA
df1$address <- gsub(",.*", "\\1", df1$`Facility Street Address (including zip)`)

#converting data
df1$address <- toupper(df1$address)
#removing periods
df1$address <- gsub('\\.', '', df1$address)

#matching conversion
df1$address <- gsub(' AVE ',' AVENUE ', df1$address)
df1$address <- gsub(' ST ',' STREET ', df1$address)
df1$address <- gsub(' DR ',' DRIVE ', df1$address)
df1$address <- gsub(' LN ',' LANE ', df1$address)
df1$address <- gsub(' RD ',' ROAD ', df1$address)
df1$address <- gsub(' BLVD ',' BOULEVARD ', df1$address)
df1$address <- gsub(' CIR ',' CIRCLE ', df1$address)
df1$address <- gsub(' CT ',' COURT ', df1$address)
df1$address <- gsub(' WY ',' WAY ', df1$address)
df1$address <- gsub(' W ',' WEST ', df1$address)
df1$address <- gsub(' W. ',' WEST ', df1$address)
df1$address <- gsub(' E ',' EAST ', df1$address)
df1$address <- gsub(' E. ',' EAST ', df1$address)
df1$address <- gsub(' N ',' NORTH ', df1$address)
df1$address <- gsub(' N. ',' NORTH ', df1$address)
df1$address <- gsub(' S ',' SOUTH ', df1$address)
df1$address <- gsub(' S. ',' SOUTH ', df1$address)
df1$address <- gsub(' CTR ',' CENTER ', df1$address)
df1$address <- gsub(' PKWY ',' PARKWAY ', df1$address)

##########################################################################
###################### fuzzy matching data ###############################
##########################################################################
df1$ML_match <- "" #empty column
df1$ML_ID <- "" #empty column

for (i in 1:dim(df1)[1]) {
  x <- agrep(df1$address[i], BIG_DOC$FACILITY_ADDRESS,
             ignore.case=TRUE, value=TRUE,
             max.distance = 0.1, useBytes = TRUE)
  x <- paste0(x,"")
  df1$ML_match[i] <- x
  df1$ML_ID[i] <- filter(BIG_DOC, grepl(x, FACILITY_ADDRESS))$FACILITY_ID

}

#dplyr::filter(BIG_DOC, grepl("5125 CHICAGO AVENUE", FACILITY_ADDRESS))$FACILITY_ID


writexl::write_xlsx(df1, "LTCF_Vaccine_Access_Assistance_Requests.xlsx")




