
files <- c("LOR_script_data.tsv", "analysis.tsv", "report.md", "report.html", 
           "cumulatedWordsSpoken.png")
file.remove(files)

# to delete direcotory "report_files", recursive because it contains folders
# unlink("report_files", recursive = TRUE)
  # only knitting generates that folder
