Questions <- readRDS('./Questions.RDS')
Questions_1 <- Questions[which(Questions[,'Quiz'] == '1'), ]
Questions_2 <- Questions[which(Questions[,'Quiz'] == '2'), ]
Questions_3 <- Questions[which(Questions[,'Quiz'] == '3'), ]
Questions_4 <- Questions[which(Questions[,'Quiz'] == '4'), ]

Questions_5 <- Questions_3[24:nrow(Questions_3), ]
Questions_3 <- Questions_3[1:23, ]
Questions_6 <- Questions_4[29:nrow(Questions_4), ]
Questions_4 <- Questions_4[1:28, ]

# Answers
Alist <- vector('list', 6)

Alist[[1]] <- Questions_1[, c('Quiz', 'Reponse')]
Alist[[1]][,1] <- seq(1,nrow(Alist[[1]]))

Alist[[2]] <- Questions_2[, c('Quiz', 'Reponse')]
Alist[[2]][,1] <- seq(1,nrow(Alist[[2]]))

Alist[[3]] <- Questions_3[, c('Quiz', 'Reponse')]
Alist[[3]][,1] <- seq(1,nrow(Alist[[3]]))

Alist[[4]] <- Questions_4[, c('Quiz', 'Reponse')]
Alist[[4]][,1] <- seq(1,nrow(Alist[[4]]))

Alist[[5]] <- Questions_5[, c('Quiz', 'Reponse')]
Alist[[5]][,1] <- seq(1,nrow(Alist[[5]]))

Alist[[6]] <- Questions_6[, c('Quiz', 'Reponse')]
Alist[[6]][,1] <- seq(1,nrow(Alist[[6]]))


colnames(Alist[[1]]) <- colnames(Alist[[2]]) <- colnames(Alist[[3]]) <- colnames(Alist[[4]]) <- colnames(Alist[[5]]) <- colnames(Alist[[6]]) <- c('N','A')


# Questions
Qlist <- vector('list', 6)
Qlist[[1]] <- Questions_1
Qlist[[2]] <- Questions_2
Qlist[[3]] <- Questions_3
Qlist[[4]] <- Questions_4
Qlist[[5]] <- Questions_5
Qlist[[6]] <- Questions_6


Qlist[[1]][,1] <- seq(1,nrow(Qlist[[1]]))
Qlist[[2]][,1] <- seq(1,nrow(Qlist[[2]]))
Qlist[[3]][,1] <- seq(1,nrow(Qlist[[3]]))
Qlist[[4]][,1] <- seq(1,nrow(Qlist[[4]]))
Qlist[[5]][,1] <- seq(1,nrow(Qlist[[5]]))
Qlist[[6]][,1] <- seq(1,nrow(Qlist[[6]]))


colnames(Qlist[[1]]) <- colnames(Qlist[[2]]) <- colnames(Qlist[[3]]) <- colnames(Qlist[[4]]) <- colnames(Qlist[[5]]) <- colnames(Qlist[[6]]) <-  c('N','Q','C1','C2','C3','C4')

for(i in 1:length(Qlist)) {
    for(j in 1:nrow(Qlist[[i]])) {
        choix <- Qlist[[i]][j,3:6]
        choix <- choix[sample(4,4,replace = FALSE)]
        Qlist[[i]][j,3:6] <- choix
    }
}

Alist[[2]] <- Alist[[2]][-c(1,2,3,4,5,6), ]
Qlist[[2]] <- Qlist[[2]][-c(1,2,3,4,5,6), ]
Alist[[2]][,1] <- seq(1,nrow(Alist[[2]]))
Qlist[[2]][,1] <- seq(1,nrow(Qlist[[2]]))











save(Alist, file = './Survey/Alist.RData')
save(Qlist, file = './Survey/Qlist.RData')
