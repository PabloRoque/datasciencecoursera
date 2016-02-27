# Plot 4

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
# Modifying par() to get 2 rows by 2 columns
par(mfrow = c(2, 2)) 
# Plot (1,1)
plot(dt$Date+dt$Time, dt$Global_active_power, type="l", 
     xlab="", ylab="Global Active Power")
# Plot (1,2)
plot(dt$Date+dt$Time, dt$Voltage, type="l", xlab="datetime", ylab="Voltage")
# Plot (2,1)
plot(dt$Date+dt$Time, dt$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(dt$Date+dt$Time, dt$Sub_metering_2, col="red")
lines(dt$Date+dt$Time, dt$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), lty=c(1,1,1), bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# Plot (2,2)
plot(dt$Date+dt$Time, dt$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global_reactive_power")

# Plotting to a png graphic device
png('Plot4.png', width = 480, height = 480, units = "px")
par(mfrow = c(2, 2)) 
# Plot (1,1)
plot(dt$Date+dt$Time, dt$Global_active_power, type="l", 
     xlab="", ylab="Global Active Power")
# Plot (1,2)
plot(dt$Date+dt$Time, dt$Voltage, type="l", xlab="datetime", ylab="Voltage")
# Plot (2,1)
plot(dt$Date+dt$Time, dt$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(dt$Date+dt$Time, dt$Sub_metering_2, col="red")
lines(dt$Date+dt$Time, dt$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), lty=c(1,1,1), bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# Plot (2,2)
plot(dt$Date+dt$Time, dt$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global_reactive_power")
dev.off()


