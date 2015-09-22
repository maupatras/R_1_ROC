ComputeROC <- function(matData,varName,factorName,numBootstraps=50){
  library(pROC)
  #suppressMessages(library(pROC))
  library(data.table)
  library(ggplot2)
  names(matData) <- c("fact","var")
  
  roc1 <- roc(fact~var,data = matData, direction = ">",ci=T,plot=F)
  #roc1 <- roc(patient~RAVLT1,data = d2, direction = ">",ci=T,of="sp",boot.n=100)
  
  dfplot <- data.table(OneMinusSpec=1-roc1$specificities,Sensitivity=roc1$sensitivities)
  # plot1 <- ggplot(data = dfplot,aes(x=OneMinusSpec,y=Sensitivity))+geom_point(size=4)+geom_line(size=1.5)+xlab("1 - Specificity")+
  #   ggtitle(paste0("ROC curve for ",curVar))+geom_abline(intercept=0,slope=1,size=1.5)+xlim(c(0,1))+ylim(c(0,1))
  
#   plot1 <- ggplot(data = dfplot,aes(x=OneMinusSpec,y=Sensitivity))+geom_point()+geom_line()+
#     xlab("1 - Specificity")+  ggtitle(paste0("ROC curve for ",varName))+
#     geom_segment(aes(x = 0, xend = 1, y = 0 , yend = 1))
#   plot(plot1)
  
  
  matRoc1 <- data.frame(thresholds=roc1$thresholds,sensitivities=roc1$sensitivities,specificities=roc1$specificities)
  ci_se_roc1 <- ci.se(roc1,specificities = roc1$specificities,boot.n = numBootstraps)
  ci_sp_roc1 <- ci.sp(roc1,sensitivities = roc1$sensitivities,boot.n = numBootstraps)
  #cbind(roc1$thresholds,roc1$sensitivities,roc1$specificities,ci_se_roc1)
  k1 <- ci.thresholds(roc1,boot.n = numBootstraps)
  k2<-cbind(roc1$thresholds,roc1$sensitivities,roc1$specificities)#,k1$sensitivity,k1$specificity)
  k1sens <- data.frame(k1$sensitivity)
  k1sens$thresholds <- as.numeric(row.names(k1sens))
  names(k1sens) <- c(paste0("sensitivity",c(" 2.5%",""," 97.5%")),"threshold")
  k1spe <- data.frame(k1$specificity)
  k1spe$thresholds <- as.numeric(row.names(k1spe))
  names(k1spe) <- c(paste0("specificity",c(" 2.5%",""," 97.5%")),"threshold")
  k1SensSpe <- merge(k1sens,k1spe,by = "threshold")
  k1SensSpe <- k1SensSpe[order(k1SensSpe$sensitivity,decreasing = T),]
  k1SensSpe <- data.table(k1SensSpe[!k1SensSpe$threshold%in%c(Inf,-Inf),])
  
  
  #curThreshold<-8.5
  ComputePPVNPV <- function(curThreshold){
    mainVar <- matData$var
    mainGroup <- matData$fact
    mainPredGroup <- factor(mainVar<curThreshold,labels = c("Negative","Positive"))
    mainPredGroup <- relevel(mainPredGroup,"Positive")
    t1<-table(mainPredGroup,mainGroup)
    PPV <- t1[1,2]/sum(t1[1,])
    NPV <- t1[2,1]/sum(t1[2,])
    return(c(PPV,NPV))
  }
  
  matPPVNPV <- data.table(t(sapply(k1SensSpe$threshold,FUN = ComputePPVNPV)))
  setnames(matPPVNPV,c("PPV","NPV"))
  k1SensSpe2 <- data.table(k1SensSpe, matPPVNPV)
  k1SensSpe2 <- k1SensSpe2[,lapply(.SD, function(x) paste0(round(x*100,1),"%")),by=threshold]
  
  #print(kable(xtable(k1SensSpe2),caption =paste(varName,paste(levels(matData$fact),collapse = "-"))))
  #print(kable(xtable(as.data.frame(k1SensSpe2))))
  #print(kable(k1SensSpe2))
  toReturn<-c()
  toReturn[[1]] <- k1SensSpe2
  #toReturn <- k1SensSpe2
  #cat("\n\n")

  plot1 <- ggplot(data = dfplot,aes(x=OneMinusSpec,y=Sensitivity))+geom_point()+geom_path()+
          xlab("1 - Specificity")+  ggtitle(paste0("ROC curve for ",varName,"  (AUC=",round(roc1$auc,4),")"))+
          geom_segment(aes(x = 0, xend = 1, y = 0 , yend = 1))
  #print(plot1)
  #cat("  \nArea under the curve:",roc1$auc,"\n")
  #print(roc1$auc)
  toReturn[[2]] <- plot1
  return(toReturn)
}