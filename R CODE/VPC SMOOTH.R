if(Sys.getenv("R_LIB") != "") { .libPaths(c(Sys.getenv("R_LIB"), .libPaths())) }
library(xpose4)
library(ggplot2)
library(reshape)

models <- #PIRANA_IN
  folder <- "C:/Users/jack/Desktop/NONMEMPLAYING/vpc_294"  # VPC_281 폴더 경로 설정

# ------------------------------ some plot settings -------------------
idv    ='TIME'
idv.lab="Time (h)"
dv.lab="Bortezomib concentration (ng/mL)"
strat.name=NULL # vector of names of the stratification levels in the same order as the original levels, set NULL to use the orginal levels
ci    =95 #confidence level
up.pi =95 # upper percentile of prediction interval
lo.pi = 5 # lower percentile of prediction interval
logy  = FALSE # log transform y-axis
drop.level = NULL # vector of excluded stratification levels

# color of CI areas
ci.out.col = "#002288"
ci.med.col = "#882222"
# line color of observed percentiles
obs.med.col="#882222"
obs.per.col="#222288"
col.obs="#444444"
line.size.per = 0.5
line.size.med = 1
#  ------------------------------------------------------------------------

command <- readLines(paste(folder, "/command.txt", sep=""))
args <- strsplit(command, " ")[[1]][-1]
for (i in seq(args)) { if(substr(args[i],0,1) != "-") { modfile <- args[i] } }
runno <- strsplit(modfile, "\\.")[[1]][1]

csv_file <- dir(folder, pattern="raw_result")[1]
fname <- paste(folder, "/vpc_", folder, "_smooth.pdf", sep="")
if (runno != "") {
  fname <- paste(folder, "/",runno,"_vpc_smooth.pdf", sep="")
}

if (!file.exists(folder)) {dir.create (folder)}
if (file.exists(fname)){
  file.remove(fname)
}

# 직접 경로 지정
vpc.info <- paste(folder, "/vpc_results.csv", sep="")
vpctab <- paste(folder, "/vpctab", sep="")

if (!file.exists(vpctab) | !(file.exists(vpc.info))) {
  cat ("VPC output not found. The vpc in PsN probably failed.")
  quit()
}

tab <- read.vpctab(vpctab)
vpc <- read.npc.vpc.results(vpc.info)
vpc_tmp <- vpc$result.tables
tab_dat <- tab@Data

## handle stratification (if present)
n_strata <- length(vpc$strata.names)

if (n_strata > 1) {
  
  vpc_dat <- c()
  for(i in 1:n_strata){
    tmp <- cbind(vpc_tmp[[i]],strata_no = i)
    vpc_dat <- rbind(vpc_dat, tmp)
  }
  if(is.null(strat.name)){
    vpc_dat$strata_name <- factor(vpc$strata.names[vpc_dat$strata_no])
    tab_dat$strata_name <- factor(vpc$strata.names[tab_dat$strata_no])
  } else {
    vpc_dat$strata_name <- factor(strat.name[vpc_dat$strata_no])
    tab_dat$strata_name <- factor(strat.name[tab_dat$strata_no])
  }
  # drop stratification level
  if(!is.null(drop.level)){
    vpc_dat <- subset(vpc_dat,!strata_name%in%drop.level)
    tab_dat <- subset(tab_dat,!strata_name%in%drop.level)
  }
  pl <- ggplot(tab_dat, aes(group=strata_name)) + facet_wrap (~ strata_name)
} else {
  vpc_dat <- vpc_tmp
  # drop stratification level
  if(!is.null(drop.level)){
    vpc_dat <- subset(vpc_dat,!strata_name%in%drop.level)
    tab_dat <- subset(tab_dat,!strata_name%in%drop.level)
  }
  
  pl <- ggplot(tab_dat)
}

# enlarge limits to allow plotting of confidence intervals
xlim <- c(min(c(vpc_dat$lower, tab_dat[[idv]]), na.rm=TRUE), max(c(vpc_dat$upper, tab_dat[[idv]]), na.rm=TRUE))
ylim <- c(min(c(vpc_dat[[paste0(ci,'.CI.for.',lo.pi,'.from')]], tab_dat$DV), na.rm=TRUE), max(c(vpc_dat[[paste0(ci,'.CI.for.',up.pi,'.to')]], tab_dat$DV), na.rm=TRUE))

# for unbinned VPCs
if (is.na(vpc_dat$lower[1])) {
  vpc_dat$lower <- vpc_dat$upper - min(diff(vpc_dat$upper))/2
  vpc_dat$upper <- vpc_dat$upper + min(diff(vpc_dat$upper))/2
  xlim[2] <- xlim[2] * 1.02
}

# plot all layers
pl <- pl +
  geom_ribbon(data=vpc_dat, aes_string(x='(upper+lower)/2', ymin=paste0('`',ci,'.CI.for.',lo.pi,'.from`'),
                                       ymax=paste0('`',ci,'.CI.for.',lo.pi,'.to`')), linetype=0, alpha=0.5, fill=ci.out.col) +
  geom_ribbon(data=vpc_dat, aes_string(x='(upper+lower)/2', ymin=paste0('`',ci,'.CI.for.',up.pi,'.from`'),
                                       ymax=paste0('`',ci,'.CI.for.',up.pi,'.to`')), linetype=0, alpha=0.5, fill=ci.out.col) +
  geom_ribbon(data=vpc_dat, aes_string(x='(upper+lower)/2', ymin=paste0('`',ci,'.CI.for.50.from`'),
                                       ymax=paste0('`',ci,'.CI.for.50.to`')), linetype=0, alpha=0.5, fill=ci.med.col) +
  geom_line(data=vpc_dat, aes_string(x='(upper+lower)/2', y="`50.real`"), size=0.5, colour=obs.med.col) +  # 실선 굵기를 0.5로 설정
  geom_line(data=vpc_dat, aes_string(x='(upper+lower)/2', y=paste0("`",lo.pi,".real`")), size=0.3, linetype="solid", colour=obs.per.col) +  # 실선 굵기를 0.3으로 설정
  geom_line(data=vpc_dat, aes_string(x='(upper+lower)/2', y=paste0("`",up.pi,".real`")), size=0.3, linetype="solid", colour=obs.per.col) +  # 실선 굵기를 0.3으로 설정
  xlab(idv.lab) +
  ylab(dv.lab) +
  xlim(xlim) +
  ylim(ylim) +
  theme_bw()


if(logy == TRUE){
  pl <- pl + scale_y_log10()
}

pdf(file=fname, height=6, width=8, useDingbats=F)
print(pl)
dev.off()
