# author: Oscar Yik
# date: 2026-03-15

"This script loads data for online purchasing behavior from the internet. It will
use the backup file in `data/raw/` if the UCI database is experiencing outages.
Usage: data_loading.R --input_url=<input_url> --output_file_path=<output_file_path>

Options:
--input_url=<input_url>      URL to download online puchasing behavior data zip file
--output_file_path=<output_file_path>      Path to save output data csv file
" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)

main <- function(input_url, output_file_path) {
  backup_file_path <- "data/raw/online+shoppers+purchasing+intention+dataset.zip"

  tryCatch({
    temp <- tempfile()
    download.file(input_url, destfile=temp)
    files <- unzip(temp, exdir = tempdir())
    file.copy(from = files[1], to = output_file_path, overwrite = TRUE)
    message(paste("Online purchasing behavior dataset has been loaded to", output_file_path))
  }, error = function(e) {
    message("UCI is down (5xx status code). Check connection, using local backup...")
    files <- unzip(backup_file_path, exdir = tempdir())
    file.copy(from = files[1], to = output_file_path, overwrite = TRUE)
  })
}

main(opt$input_url, opt$output_file_path)
