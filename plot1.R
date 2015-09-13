## Read the dataset into R.

dataset <- read.table(file = "household_power_consumption.txt", skip = 1, sep = ';', 
                na.strings = "?", dec = '.', 
                colClasses = c(rep("character", 2), rep("numeric", times = 7)))

## Name the columns in dataset
names(dataset) <- c("Date", "Time", "Global Active Power", "Global Reactive Power",
                    "Voltage", "Global Intensity", "Sub Metering 1", "Sub Metering 2",
                    "Sub Metering 3")

## Convert the dates and time in dataset to "Date" and "POSIXct" class
library(lubridate)
dataset[, 1] <- as.Date(dmy(dataset[, 1]))
dataset[, 2] <- hms(dataset[, 2])

## Set the dates of the data we'll be using
begin <- as.Date("2007/02/01")
end <- as.Date("2007/02/02")

## Subset the data to plot
plotdata <- subset(dataset, dataset$Date == end | dataset$Date == begin)

## Construct plot 1
png("plot1.png")
hist(plotdata[, 3], col = 'red',
     main = 'Global Active Power',
     xlab = 'Global Active Power (kilowatts)')
dev.off()