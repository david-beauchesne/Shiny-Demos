loadData <- function() {
    # Read all the files into a list
    filesInfo <- drop_dir('/phd/misc/surveytool/survey/server_files')
    filePaths <- filesInfo$path
    data <- lapply(filePaths, drop_read_csv, stringsAsFactors = FALSE)
    # Concatenate all data together into one data.frame
    data <- do.call(rbind, data)
    name <- quiz <- character()
    for(i in 1:nrow(data)){
        name <- c(name, substr(data[i,1], start = 1, stop = nchar(data[i,1])-2))
        quiz <- c(quiz, substr(data[i,1], start=nchar(data[i,1]), stop=nchar(data[i,1])))
    }
    data <- cbind(data,name,quiz)
    data <- data[order(data[,'name']), ]
    plot_table <- aggregate(x = data[,2], by = list(name = data[,'name']), FUN = sum)
    rownames(plot_table) <- plot_table[,'name']
    colnames(plot_table) <- c('name','Total')
    plot_table <- rbind(plot_table, data.frame(name = '', Total = rep(0, 16-nrow(plot_table))))
    return(plot_table)
}
