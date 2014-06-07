zipFileName <- "./data/exdata-data-household_power_consumption.zip"
txtFileName <- './data/household_power_consumption.txt'

if (!file.exists("./data")) { dir.create("./data") }

if (!file.exists(zipFileName)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, destfile = zipFileName, method="curl")
  list.files("./data")
  dateDownloaded <- date()
}

if (!file.exists(txtFileName)) {
  unzip(zipFileName, overwrite = FALSE, exdir = "./data")
}

library(sqldf)

# Read the data in that corresponds to Feb 1-2, 2007
data <- read.csv2.sql(txtFileName, sep = ";", sql = 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"')

# Convert the Date and Time fields to a Date class
data$DateTime <- paste(data$Date, data$Time, sep = " ")
data$DT <- strptime(data$DateTime, format = "%d/%m/%Y %H:%M:%S")
data$DateTime <- NULL

#Note that in this dataset missing values are coded as ?, 
# so convert those to NA values
data[] <- lapply(data, function(x){replace(x, x == "?", NA)})

#Write the histogram out to a file
png(filename = 'plot1.png', width = 480, height = 480)
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()