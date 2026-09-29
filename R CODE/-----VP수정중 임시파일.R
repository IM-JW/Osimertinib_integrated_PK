#START OF AUTO-GENERATED PREAMBLE, WILL BE OVERWRITTEN WHEN THIS FILE IS USED AS A TEMPLATE
#Created 2025-08-10 at 11:38

xpose.runno <- '1025'
toolname <- 'vpc'
pdf.filename <- paste0('PsN_',toolname,'_plots.pdf')
working.directory<-'C:\\Users\\isuji\\Desktop\\Ph.D\\Research\\Osimertinib\\NONMEM\\VER5.6\\VALI\\run\\vpc_run1025\\'
results.directory <- '..'
subset.variable<-NULL
tab.suffix <- '' 
rscripts.directory <- 'C:/PsN-5.4.0/strawberry/perl/site/lib/PsN_5_4_0/R-scripts' # This is not used
tool.results.file <- 'vpc_results.csv'
theta.labels <- c('1 KA','2 CL','3 CLM','4 V','5 VM','6 FMET','7 ADD','8 PRO','9 ADD','10 PRO','11 CL_WT','12 V_WT','13 CLM_WT','14 CLM_AGE','15 VM_AGE','16 CL_ALB','17 CLM_ALB','18 V_ALB','19 CL_AST','20 CLM_AST','21 V_AST','22 VM_AST','23 CLM_SEX','24 VM_SEX')
theta.fixed <- c(TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)
omega.labels <- c('IIV-KA','IIV-CL','IIV-CLM','IIV-V','IIV-VM','IIV-FM')
omega.fixed <- c(TRUE,FALSE,FALSE,FALSE,FALSE,TRUE)
sigma.labels <- c('SIGMA(1,1)','SIGMA(2,2)')
sigma.fixed <- c(TRUE,TRUE)
n.eta <- 6
n.eps <- 2

vpctab <- 'vpctab'
have.loq.data <- FALSE
have.censored <- FALSE
is.categorical <- FALSE
is.tte <- FALSE
dv <- 'DV'
idv <- 'TIME'
samples <- 1000
stratify_on <- c('CMT')

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
library(vpc)
library(ggplot2)

#add R_info to the meta file
R_info(directory=working.directory)
meta <- PsNR::metadata(working.directory)

if (is.tte) {
  #data is in the model directory, go there to read input
  setwd(dirname(PsNR::model_path(meta)))
  capture.output(xpdb <- xpose4::xpose.data(PsNR::model_runno(meta)))
  plots <- xpose4::kaplan.plot(object=xpdb, VPC=T)
  #go back to vpc directory 
  setwd(working.directory)
} else if (is.categorical) { 
  plots <- xpose4::xpose.VPC.categorical(vpc.info=tool.results.file, vpctab=vpctab)
} else if (have.loq.data | have.censored) {
  plots <- xpose4::xpose.VPC.both(vpc.info=tool.results.file, vpctab=vpctab)
} else {
  plots <- xpose4::xpose.VPC(vpc.info=tool.results.file, vpctab=vpctab)
}
print(plots) 

## ----- ADD: save CMT==2 and CMT==3 plots separately -----
## vpc::read_nonmem_table 가 export되지 않는 환경을 고려해 base R로 npctab 읽기
if (requireNamespace("vpc", quietly = TRUE)) {
  observations_tablefile <- file.path(working.directory, 'm1', 'vpc_original.npctab.dta')
  simulations_tablefile  <- file.path(working.directory, 'm1', 'vpc_simulation.1.npctab.dta')
  
  if (file.exists(observations_tablefile) && file.exists(simulations_tablefile)) {
    
    # PsN npctab(dta)은 공백 구분 헤더 포함이 일반적이므로 read.table 기본값으로 시도
    read_nm <- function(path) {
      tryCatch(
        utils::read.table(path, header = TRUE, sep = "", stringsAsFactors = FALSE, check.names = FALSE),
        error = function(e) utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
      )
    }
    
    obs_all <- read_nm(observations_tablefile)
    sim_all <- read_nm(simulations_tablefile)
    
    # vpc_results.csv에서 Independent variable(=IDV) 이름 파싱
    vpc_res_path <- file.path(working.directory, 'vpc_results.csv')
    if (file.exists(vpc_res_path)) {
      vpc_res <- read.csv(vpc_res_path, skip = 1, nrows = 1, stringsAsFactors = FALSE)
      idv <- trimws(vpc_res$Independent.variable)
    } # 없으면 preamble의 idv 그대로 사용
    
    dv_name <- dv  # preamble 변수 사용
    
    save_cmt_plot <- function(cmt_val) {
      if (!("CMT" %in% names(obs_all)) || !("CMT" %in% names(sim_all))) {
        message("CMT 컬럼이 테이블에 없습니다. PsN 설정을 확인하세요 (예: DVID 사용 여부).")
        return(invisible(NULL))
      }
      obs <- subset(obs_all, CMT == cmt_val)
      sim <- subset(sim_all, CMT == cmt_val)
      if (nrow(obs) == 0 || nrow(sim) == 0) {
        message(sprintf("CMT==%d 데이터가 없어 건너뜁니다.", cmt_val))
        return(invisible(NULL))
      }
      
      # 필요 시 id 컬럼 지정 (테이블에 ID가 있으면 전달)
      obs_cols_list <- list(dv = dv_name, idv = idv)
      sim_cols_list <- list(dv = dv_name, idv = idv)
      if ("ID" %in% names(obs)) obs_cols_list$id <- "ID"
      if ("ID" %in% names(sim)) sim_cols_list$id <- "ID"
      
      vp <- vpc::vpc(
        obs = obs, sim = sim,
        obs_cols = obs_cols_list,
        sim_cols = sim_cols_list,
        stratify = NULL   # 단일 CMT만 그림 (facet 없음)
        # bins 생략 → vpc 기본 bin 사용
      )
      
      out_pdf <- paste0('PsN_', toolname, '_plots_CMT', cmt_val, '.pdf')
      pdf(file = out_pdf, width = 10, height = 7, onefile = FALSE)
      print(vp + ggplot2::ggtitle(paste0("CMT == ", cmt_val)))
      dev.off()
    }
    
    # 각각 별도 PDF로 저장 (한 파일당 한 그래프, 페이지 병합 없음)
    save_cmt_plot(2)
    save_cmt_plot(3)
  }
}
## ----- END ADD -----

if (exists('mix')) {     # A mixture model is a special case
  if (require("vpc")) {
    cat("<BR>")
    observations_tablefile <- paste0(working.directory, '/m1/vpc_original.npctab.dta')
    simulations_tablefile <- paste0(working.directory, '/m1/vpc_simulation.1.npctab.dta')
    
    obs <- read_nonmem_table(observations_tablefile)
    sim <- read_nonmem_table(simulations_tablefile)
    obs_phm <- read_nonmem_table(phm_obs_file)
    sim_phm <- read_nonmem_table(phm_sim_file)
    if (!exists('stratify_on')) {
      stratify_on <- NULL
    }
    
    # Read name of IDV from vpc_results.csv
    vpc_res <- read.csv(paste0(working.directory, '/vpc_results.csv'), skip=1, nrows=1, stringsAsFactors=FALSE)
    idv <- trimws(vpc_res$Independent.variable)
    
    vpc <- vpc::vpc(obs=obs, sim=sim, obs_cols=list(dv=dv, idv=idv), sim_cols=list(dv=dv, idv=idv), stratify=stratify_on, bins=bin_boundaries)
    print(vpc)
    plots_mixest <- mixture_vpc(obs, sim, obs_phm, sim_phm, dv=dv, idv=idv, bins=bin_boundaries, stratify_on=stratify_on)
    plots_randomized <- mixture_vpc(obs, sim, obs_phm, sim_phm, dv=dv, idv=idv, bins=bin_boundaries, stratify_on=stratify_on, randomize=TRUE)
    plots <- list()
    for (i in 1:length(plots_mixest)) {
      mixest <- plots_mixest[[i]]
      randomized <- plots_randomized[[i]]
      if (is.character(mixest) || is.character(randomized)) {     # An error message instead of plot
        cat("\\pagebreak\n\n")
        cat(p)
        cat("\\pagebreak")
      } else {
        plots[[2*i - 1]] <- mixest
        plots[[2*i]] <- randomized
      }
    }
    print(gridExtra::marrangeGrob(plots, nrow=2, ncol=2, top=NULL, padding=0))
    cat('<BR>')
    plots <- list()
    for (i in unique(obs_phm$SUBPOP)) { # Allowing cases with more than 2 mixtures
      temp_obs <- obs_phm %>% dplyr::filter(SUBPOP == i) %>% 
        dplyr::arrange(PMIX) %>% 
        dplyr::mutate(rank=1:dplyr::n()) # Get rank for the plot
      temp_sim <- sim_phm %>% dplyr::filter(SUBPOP == i) %>% 
        dplyr::group_by(replicate) %>% # Assuming replicate is the simulation number
        dplyr::arrange(PMIX) %>% 
        dplyr::mutate(rank = 1:dplyr::n()) %>%  # Get rank for the plot by simulation
        dplyr::group_by(rank) %>% 
        dplyr::summarise(per5=quantile(PMIX, probs=c(0.05)), 
                         per95=quantile(PMIX, probs=c(0.95))) # Get percentiles among simulations
      
      plots[[i]] <- ggplot() + 
        geom_ribbon(data=temp_sim, aes(rank, ymin=per5, ymax=per95), alpha=0.2) +
        geom_text(data=temp_obs, aes(rank, PMIX, label=SUBJECT_NO), size=8) +
        geom_hline(yintercept=0.5, linetype="dashed", size=2) +
        theme_classic() +
        theme(axis.text.y=element_text(size=20),
              axis.title.y=element_blank(),
              axis.ticks.y=element_line(size=3),
              axis.ticks.length=unit(6, "pt"),
              axis.ticks.x=element_blank(),
              axis.title.x=element_text(size=25),
              axis.text.x=element_blank()) +
        xlab(paste0("SUBPOP=", i))
      if (i > 1) {
        plots[[i]] <- plots[[i]] + theme(axis.text.y=element_blank(), axis.ticks.y=element_blank())
      }
    }
    
    left_axis = grid::textGrob("IPmix", gp=grid::gpar(font=2,fontsize=25), rot=90)
    bottom_axis = grid::textGrob("Sorted ID", gp=grid::gpar(font=2,fontsize=25))
    title = grid::textGrob("IPmix with uncertainty 5-95% CI", gp=grid::gpar(font=2,fontsize=35))
    gridExtra::marrangeGrob(plots, nrow=1, ncol=2, top=title, left=left_axis, bottom=bottom_axis)
  }
}
dev.off()
