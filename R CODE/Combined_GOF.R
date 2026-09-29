### R script supplied with Pirana
###
### Required: - NM table file with DV, PRED, IPRED, TIME, CWRES on first $TABLE record
###
### Description: This R-script create four basic GOF plots
###

if(Sys.getenv("R_LIB") != "") { .libPaths(c(Sys.getenv("R_LIB"), .libPaths())) }
library(lattice)
library(grid)

req.fields <- c("DV", "PRED", "IPRED", "TIME", "CWRES")
models <- #PIRANA_IN
model_names <- names(models)
if (!file.exists("pirana_reports")) {dir.create ("pirana_reports")}
for (i in 1:length(model_names)) {
    fname <- paste("pirana_reports/",names(models)[i],"_GOF.pdf", sep="")
    header<- paste("Goodness of fit model",names(models)[i], sep=" ")
    if (file.exists (fname)){
        file.remove (fname)
    }
    mod      <- models[[model_names[i]]]
    tab_file <- c(mod$tables[grep("sdtab", mod$tables)])[1]
    if (is.na(tab_file)) { # then assume the first table has the gof variables
        tab_file <- mod$tables[1]
    }
    if (file.exists (tab_file)) {
        tab <- read.table (tab_file, skip=1, header=T) # NONMEM table with ONEHEADER option
        m <- match (names(models[[model_names[i]]]$input_trans), colnames(tab))        # tranlation of $INPUT variables
        colnames(tab)[m] <- unlist (models[[model_names[i]]]$input_trans, use.names=F) # tranlation of $INPUT variables
        if ("MDV" %in% names(tab)) { tab <- tab[tab$MDV==0,] }                       # check if MDV present
        if ("EVID" %in% names(tab)) { tab <- tab[tab$EVID==0,] }                     # check if EVID present
        not.found <- req.fields[is.na(match(req.fields, colnames(tab)))]
        if ( length (not.found) > 0) {
          cat (paste("The variable(s)",not.found,"were not found. Please check your output tables.\nStopping R execution."))
          quit()
        }
########################################################################################################
# R code for plotting starts here
        pan2 <- function(x,y,...)    {
            panel.xyplot(x,y,...)
            panel.abline(0,1,col="black")
            panel.loess(x,y,col="red", lwd=1)
            }

        pan3 <- function(x,y,...)    {
            panel.xyplot(x,y,...)
            panel.abline(0,0,col="black")
            panel.abline(1.96,0,col="black",lty=2)
            panel.abline(-1.96,0,col="black",lty=2)
            panel.lmline(x,y,col="red",lwt=2)
        }

# CMT = 1에 대한 lim 계산
ipredlim_cmt1 <- range(tab$IPRED[tab$CMT == 1]) * c(0.95, 1.05)
dvlim_cmt1 <- range(tab$DV[tab$CMT == 1]) * c(0.95, 1.05)
lim1_cmt1 <- range(c(ipredlim_cmt1, dvlim_cmt1))
reslim_cmt1 <- range(tab$CWRES[tab$CMT == 1]) * 1.05

# CMT = 3에 대한 lim 계산
ipredlim_cmt3 <- range(tab$IPRED[tab$CMT == 3]) * c(0.95, 1.05)
dvlim_cmt3 <- range(tab$DV[tab$CMT == 3]) * c(0.95, 1.05)
lim1_cmt3 <- range(c(ipredlim_cmt3, dvlim_cmt3))
reslim_cmt3 <- range(tab$CWRES[tab$CMT == 3]) * 1.05

# CWRES tick marks 설정
tick <- c(-5, -2, 0, 2, 5)


# Individual Predictions vs. Observed Concentrations Plot for CMT=1
        pl1 <- 	xyplot(DV~IPRED | CMT, data = tab[tab$CMT == 1,],
                       panel=pan2,
                       type="p", cex=0.5,
                       ylab=list("Observed concentration",cex=0.7, just=c(0.5,2.5)),
                       xlab=list("Individual predicated concentration", cex=0.7, just=c(0.5,-1)),
                       scales=list (tck=c(1, 0),x=list(cex=0.5),y= list(cex=0.5)),
                       ylim=lim1_cmt1,
                       xlim=lim1_cmt1,
                       main=list("Individual predictions versus concentrations (CMT=1)",cex=0.55,just=c(0.43,4))
                       )

# Population Predictions vs. Observed Concentrations Plot for CMT=1
        pl2 <- 	xyplot(DV~PRED | CMT, data = tab[tab$CMT == 1,],
                       panel=pan2,
                       type="p", cex=0.5,
                       ylab=list("Observed concentration",cex=0.7, just=c(0.5,2.5)),
                       xlab=list("Population predicated concentration",cex=0.7,just=c(0.5,-1)),
                       ylim=lim1_cmt1,
                       xlim=lim1_cmt1,
                       scales=list (tck=c(1, 0),x=list(cex=0.5),y= list(cex=0.5)),
                       main=list("Population predictions versus concentrations (CMT=1)",cex=0.55,just=c(0.43,4))
                       )

# Conditional Weighted Residuals vs. Population Predictions Plot for CMT=1
        pl3 <- 	xyplot(CWRES ~ PRED | CMT, data = tab[tab$CMT == 1,],
                       ylim=reslim_cmt1,
                       panel=pan3,
                       type="p", cex=0.5,
                       ylab=list("CWRES",cex=0.5, just=c(0.7,3)),
                       xlab=list(" Population predicted concentration", cex=0.7,just=c(0.5,-1)),
                       scales=list (tck=c(1, 0),x=list(cex=0.5),y= list(cex=0.5, at=tick)),
                       main=list("Conditional weighted residuals versus population predictions (CMT=1)",cex=0.55,just=c(0.43,4))
                       )

# Conditional Weighted Residuals vs. Time Plot for CMT=1
        pl4 <- 	xyplot(CWRES ~ TIME | CMT, data = tab[tab$CMT == 1,],
                       ylim=reslim_cmt1,
                       panel=pan3,
                       type="p", cex=0.5,
                       ylab=list("CWRES",cex=0.5, just=c(0.7,3)),
                       xlab=list(" Time", cex=0.7,just=c(0.5,-1)),
                       scales=list (tck=c(1, 0),x=list(cex=0.5),y= list(cex=0.5, at=tick)),
                       main=list("Conditional weighted residuals versus time (CMT=1)",cex=0.55,just=c(0.43,4))
                       )

# Individual Predictions vs. Observed Concentrations Plot for CMT=3
	pl5 <- xyplot(DV ~ IPRED | CMT, data = tab[tab$CMT == 3,],
                  panel = pan2,
                  type = "p", cex = 0.5,
                  ylab = list("Observed concentration", cex = 0.7, just = c(0.5, 2.5)),
                  xlab = list("Individual predicted concentration", cex = 0.7, just = c(0.5, -1)),
                  scales = list(tck = c(1, 0), x = list(cex = 0.5), y = list(cex = 0.5)),
                  ylim = lim1_cmt3,
                  xlim = lim1_cmt3,
                  main = list("Individual predictions versus concentrations (CMT=3)", cex = 0.55, just = c(0.43, 4)))

# Population Predictions vs. Observed Concentrations Plot for CMT=3
    pl6 <- xyplot(DV ~ PRED | CMT, data = tab[tab$CMT == 3,],
                  panel = pan2,
                  type = "p", cex = 0.5,
                  ylab = list("Observed concentration", cex = 0.7, just = c(0.5, 2.5)),
                  xlab = list("Population predicted concentration", cex = 0.7, just = c(0.5, -1)),
                  ylim = lim1_cmt3,
                  xlim = lim1_cmt3,
                  scales = list(tck = c(1, 0), x = list(cex = 0.5), y = list(cex = 0.5)),
                  main = list("Population predictions versus concentrations (CMT=3)", cex = 0.55, just = c(0.43, 4)))

# Conditional Weighted Residuals vs. Population Predictions Plot for CMT=3
    pl7 <- xyplot(CWRES ~ PRED | CMT, data = tab[tab$CMT == 3,],
                  ylim = reslim_cmt3,
                  panel = pan3,
                  type = "p", cex = 0.5,
                  ylab = list("CWRES", cex = 0.5, just = c(0.7, 3)),
                  xlab = list("Population predicted concentration", cex = 0.7, just = c(0.5, -1)),
                  scales = list(tck = c(1, 0), x = list(cex = 0.5), y = list(cex = 0.5, at = tick)),
                  main = list("Conditional weighted residuals versus population predictions (CMT=3)", cex = 0.55, just = c(0.43, 4)))

# Conditional Weighted Residuals vs. Time Plot for CMT=3
    pl8 <- xyplot(CWRES ~ TIME | CMT, data = tab[tab$CMT == 3,],
                  ylim = reslim_cmt3,
                  panel = pan3,
                  type = "p", cex = 0.5,
                  ylab = list("CWRES", cex = 0.5, just = c(0.7, 3)),
                  xlab = list("Time", cex = 0.7, just = c(0.5, -1)),
                  scales = list(tck = c(1, 0), x = list(cex = 0.5), y = list(cex = 0.5, at = tick)),
                  main = list("Conditional weighted residuals versus time (CMT=3)", cex = 0.55, just = c(0.43, 4)))

########################################################################################################
    } else {
        cat (paste("The table file ",tab_file," was not found. Please check your output tables.\nStopping R execution."))
        quit()
    }
    pdf (file = fname)
 # First page: CMT=1
    print(pl3, position=c(0,-0.01,    0.52,0.51)  , more=TRUE)
    print(pl4, position=c(0.48,-0.01, 1,0.51)     , more=TRUE)
    print(pl1, position=c(0,0.45,     0.52,0.99)  , more=TRUE)
    print(pl2, position=c(0.48,0.45,  1,0.99)     , more=FALSE)
    grid.text(header,y = 0.98)

# Second page: CMT=3
    print(pl7, position=c(0,-0.01,    0.52,0.51)  , more=TRUE)
    print(pl8, position=c(0.48,-0.01, 1,0.51)     , more=TRUE)
    print(pl5, position=c(0,0.45,     0.52,0.99)  , more=TRUE)
    print(pl6, position=c(0.48,0.45,  1,0.99)     , more=FALSE)
    grid.text(header,y = 0.98)

   dev.off()

    # open created file
    cat (paste("OUTPUT: ", fname, sep=""))
    if (file.exists(fname) && open_res) {
        if (Sys.info()['sysname'] == 'Windows') { shell.exec(paste(getwd(),"/",fname,sep="")) }  # windows
	else if (Sys.info()['sysname'] == 'Darwin') { system(paste ("open ",fname, sep="")) } # mac
	else { system(paste("xdg-open ", fname, sep=""), ignore.stdout=TRUE, ignore.stderr=TRUE, wait=FALSE) } # linux
    }
}

quit()
