#Mrgsolve script for osimertinib MBMA

install.packages("mrgsolve")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("RxODE")
devtools::install_github("nlmixrdevelopment/RxODE")
install.packages("installr")
install.rtools()
devtools::session_info()

#Setting working directory (Define your own directory.)

setwd ("/Volumes/Untitled/MBMA/MBMA/REF3/CPP")
getwd ()

#Open libraries
library(mrgsolve)
library(dplyr)
library(ggplot2)

## install.packages("pkgbuild")
pkgbuild::has_build_tools(debug = TRUE)

Sys.setlocale(category = "LC_ALL", locale = "en_US.UTF-8")
# Sys.setlocale("LC_ALL", "en_US.UTF-8")
#Sys.setlocale("LC_ALL")  초기 설정으로 변경
#오류 메시지를 영문으로 보기 (영문 오류 메시지가 명확하고 구글 등의 검색을 통해서 확인하기가 편리 합니다.)
pkgbuild::check_build_tools()
pkgbuild::has_build_tools()
pkgbuild::has_rtools()



# ηCLparent-ηCLmetabolite covarianceaηc 
# 처리고민 ... 우선 CL, CLM 둘 다 *exp(4) 해둠.
#mod <- mread("CPP_2.cpp") 
#data <- expand.ev(ID = 1:500, amt = c(80000), ii = 24, addl = 5) 
#mod %>%
 # data_set(data) %>%
  #Req(CP) %>%
  #mrgsim(start=0, end=120, delta = 0.5, output="df")->a
#write.csv(a, paste("/Volumes/Untitled/MBMA/MBMA/REF3/REF3.csv"))


#######################################################################

setwd ("/Volumes/Untitled/MBMA/MBMA/REF4/CPP")
getwd ()

#Open libraries
library(mrgsolve)
library(dplyr)
library(ggplot2)


##시뮬레이션 저장 
mod <- mread("CPP.cpp", recover = TRUE) 
data <- expand.ev(ID = 1:500, amt = c(80000), ii = 24, addl = 18) 
mod %>%
  data_set(data) %>%
  Req(CP) %>%
  mrgsim(start=0, end=456, delta = 2, output="df")->a
write.csv(a, paste("/Volumes/Untitled/MBMA/MBMA/REF4/REF4.csv"))




#######################################################################



setwd ("/Volumes/Untitled/MBMA/MBMA/REF5")
getwd ()

#시뮬레이션 그래프 

mod <- mread("CPP_2.cpp", recover = TRUE) 
data <- expand.ev(ID = 1:10, amt = c(80000), ii = 24, addl = 18) 
mod %>%
  data_set(data) %>%
  Req(CP) %>%
  mrgsim(start=0, end=456, delta = 2) %>%
  plot()














