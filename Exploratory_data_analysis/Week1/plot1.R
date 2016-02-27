# Plot 1
library(data.table)
library(lubridate)
# Data source
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Download data if .zip file does not exist and unzip
if (!file.exists("data.zip")){
    download.file(url, destfile = "data.zip",method = "curl")
    unzip("data.zip")
}

# Read from file
dt <- data.table(read.csv("household_power_consumption.txt", sep = ";", header=TRUE, na.strings='?'))
# Convert to date format
dt$Date <- dmy(dt$Date) # Convert to date variable
# Dates for subsetting
Date1 <- ymd("2007-02-01")
Date2 <- ymd("2007-02-02")
# Subsetting
dt <- dt[dt$Date %in% Date1:Date2, ]
# Convert to time format, done here to avoid conveting the full data set
dt$Time <- hms(dt$Time)
 
# Plotting to default graphic device
hist(dt$Global_active_power, col = "red", 
     xlab = "Global Active Power(kiliwatts)", main = "Global active power")

# Plotting to a png graphic device
png('Plot1.png', width = 480, height = 480, units = "px")
hist(dt$Global_active_power, col = "red", 
     xlab = "Global Active Power(kiliwatts)", main = "Global active power")
dev.off()



