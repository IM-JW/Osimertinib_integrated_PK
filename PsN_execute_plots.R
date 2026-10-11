#START OF AUTO-GENERATED PREAMBLE, WILL BE OVERWRITTEN WHEN THIS FILE IS USED AS A TEMPLATE
#Created 2026-10-03 at 02:58

xpose.runno <- '104'
toolname <- 'execute'
pdf.filename <- paste0('PsN_',toolname,'_plots.pdf')
working.directory<-'C:\\Users\\admin\\Desktop\\JIWW\\Research\\Osimertinib\\NONMEM\\RERUN\\modelfit_dir5\\'
results.directory <- '..'
subset.variable<-NULL
tab.suffix <- '' 
rscripts.directory <- 'C:/PsN-5.6.0/strawberry/perl/site/lib/PsN_5_6_0/R-scripts' # This is not used
raw.results.file <- 'raw_results_run104.csv'
theta.labels <- c('1 KA','2 CL','3 CLM','4 V','5 VM','6 FMET','7 ADD','8 PRO','9 ADD','10 PRO','11 CL_WT','12 CLM_WT','13 V_WT','14 CL_ALB','15 CLM_ALB','16 V_ALB','17 VM_SEX EX','18 CLM_SEX PRO')
theta.fixed <- c(TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)
omega.labels <- c('IIV-KA','IIV-CL','IIV-CLM','IIV-V','IIV-VM')
omega.fixed <- c(TRUE,FALSE,FALSE,FALSE,FALSE)
sigma.labels <- c('SIGMA(1,1)','SIGMA(2,2)')
sigma.fixed <- c(TRUE,TRUE)
n.eta <- 5
n.eps <- 2

res.table <- '104.tab'

setwd(working.directory)

############################################################################
#END OF AUTO-GENERATED PREAMBLE
#WHEN THIS FILE IS USED AS A TEMPLATE THIS LINE MUST LOOK EXACTLY LIKE THIS


pdf(file=pdf.filename,width=10,height=7)
# get libPaths
library(PsNR)
library(magrittr)
library(methods)
library(xpose4)

#add R_info to the meta file
R_info(directory=working.directory)
meta <- PsNR::metadata(working.directory)
model_path <- PsNR::model_path(meta)
xpose_runno <- xpose.runno
model_suffix <- paste0('.', tools::file_ext(model_path))
xpdb <- xpose4::xpose.data(xpose_runno, directory=results.directory, tab.suffix=tab.suffix, mod.prefix=PsNR::model_prefix(meta), mod.suffix=model_suffix)

#uncomment below to change the idv from TIME to something else such as TAD.
#Other xpose preferences could also be changed
#xpdb@Prefs@Xvardef$idv="TAD"
xpose4::runsum(xpdb, dir=results.directory,
         modfile=PsNR::model_path(meta),
         listfile=file.path(results.directory, sub(model_suffix, ".lst", basename(PsNR::model_path(meta)))))
if (is.null(subset.variable)){
    print(xpose4::basic.gof(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::basic.gof(xpdb,by=subset.variable,max.plots.per.page=1))
}
if (is.null(subset.variable)){
    print(xpose4::ranpar.hist(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::ranpar.hist(xpdb,by=subset.variable,scales="free",max.plots.per.page=1))
}
if (is.null(subset.variable)){
    print(xpose4::ranpar.qq(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::ranpar.qq(xpdb,by=subset.variable,max.plots.per.page=1))
}
if (is.null(subset.variable)){
    print(xpose4::dv.preds.vs.idv(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::dv.preds.vs.idv(xpdb,by=subset.variable))
}
if (is.null(subset.variable)){
    print(xpose4::dv.vs.idv(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::dv.vs.idv(xpdb,by=subset.variable))
}
if (is.null(subset.variable)){
    print(xpose4::ipred.vs.idv(xpdb))
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::ipred.vs.idv(xpdb,by=subset.variable))
}
if (is.null(subset.variable)){
    print(xpose4::pred.vs.idv(xpdb))
    
}else{
    # change the subset variable from categorical to continuous or vice versa.
    # change.cat.cont(xpdb) <- c(subset.variable)
    print(xpose4::pred.vs.idv(xpdb,by=subset.variable))
}
rplots.gr.1 <- FALSE
if (PsNR::rplots_level(meta) > 1){
  rplots.gr.1 <- TRUE
  #individual plots of ten random IDs
  #find idcolumn
  idvar <- xpose4::xvardef("id",xpdb)
  ten.random.ids <- sort(sample(unique(xpdb@Data[,idvar]),10,replace=FALSE))
  subset.string <- paste0(idvar,'==',paste(ten.random.ids,collapse=paste0(' | ',idvar,'==')))

  if (is.null(subset.variable)){
    print(xpose4::ind.plots(xpdb,subset=subset.string))
  }else{
    for (flag in unique(xpdb@Data[,subset.variable])){
      print(xpose4::ind.plots(xpdb,layout=c(1,1),subset=paste0(subset.variable,'==',flag,' & (',subset.string,')')))
    }
  }
}  
if (PsNR::rplots_level(meta) > 1){
  #check if files exist
  if (res.table != '') {
      model_prefix <- PsNR::model_prefix(meta)
    file_1_exists <- file_existence_in_directory(directory=results.directory, file_name=paste0(model_prefix, xpose_runno, ".phi"))
    file_2_exists <- file_existence_in_directory(directory=results.directory, file_name=res.table)
    
    if ((file_1_exists) && (file_2_exists)) {
      # calculate data
      list_out <- data.obj.obsi(obj.data.dir=file.path(results.directory, paste0(model_prefix, xpose_runno, ".phi")),
                                obsi.data.dir=file.path(results.directory, res.table))
      have_needed_columns <- list_out$have_needed_columns
      if(have_needed_columns) {
        OBJ_data <- list_out$OBJ_data
        OBSi_vector <- list_out$OBSi_vector
        OBJ_vector <- list_out$OBJ_vecto
      
        # plot data
        PsNR::plot_obj_obsi(OBJ_data,OBSi_vector,OBJ_vector)
      }
    }
  }
}
dev.off()

