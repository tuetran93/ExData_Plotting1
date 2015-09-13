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

## Create a DateTime column for plotdata that will be used in plot3. First, create 
## a datetime function that will combine a date value and a time value into a 
## date-time value. Then, call that function on the first 2 columns of plotdata.
## Finally, bind the newly-created vector to plotdata.

datetime <- function(date, time) {
        return(as.POSIXct(x = time, origin = date, tz = 'GMT'))
}

DT <- datetime(plotdata[, 1], plotdata[, 2])

plotdata <- mutate(plotdata, DateTime = DT)

## Construct the plots
png("plot4.png")

par(mfrow = c(2, 2), mar = c(5, 5, 2, 2))

with(plotdata, plot(DateTime, `Global Active Power`,
     pch = NA_integer_, type = 'o',
     ylab = "Global Active Power", xlab = ""))

with(plotdata, plot(DateTime, Voltage, type = 'o', 
                             pch = NA_integer_, col = 'black'))

plot(plotdata$DateTime, plotdata$`Sub Metering 1`, type = 'n',
              ylab = "Energy Sub Metering", xlab = "")
with(plotdata, lines(DateTime, `Sub Metering 1`, col = 'black'))
with(plotdata, lines(DateTime, `Sub Metering 2`, col = 'red'))
with(plotdata, lines(DateTime, `Sub Metering 3`, col = 'blue'))
legend("topright", c("Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"),
       lty = c(1, 1, 1), lwd = c(1, 1, 1), col = c("black", "red", "blue"),
       bty = 'n')

with(plotdata, plot(DateTime, `Global Reactive Power`, type = 'o',
              pch = NA_integer_, col = 'black'))

dev.off()