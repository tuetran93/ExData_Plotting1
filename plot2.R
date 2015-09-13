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

## Create a DateTime column for plotdata that will be used in plot2. First, create 
## a datetime function that will combine a date value and a time value into a 
## date-time value. Then, call that function on the first 2 columns of plotdata.
## Finally, bind the newly-created vector to plotdata.

datetime <- function(date, time) {
        return(as.POSIXct(x = time, origin = date, tz = 'GMT'))
}

DT <- datetime(plotdata[, 1], plotdata[, 2])

plotdata <- mutate(plotdata, DateTime = DT)

## Construct plot 2
png("plot2.png")
par(mar = c(3, 6, 3, 3))
plot(x = plotdata$DateTime, y = plotdata$`Global Active Power`,
     pch = NA_integer_, type = 'o',
     ylab = "Global Active Power (kilowatts)")
dev.off()