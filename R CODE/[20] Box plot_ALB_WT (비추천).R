# 필요한 패키지 불러오기
library(ggplot2)
library(dplyr)

# 데이터셋 불러오기
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환 - 이미 변환되어 있음
data$WT <- cut(data$WT, breaks = seq(40, 110, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 100, by = 10), seq(50, 110, by = 10), sep = "-"))

# 'SEX'를 factor로 변환하고 'Male', 'Female'로 레이블 지정
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 25, 30, 35, 40, 45인 데이터만 필터링
data_filtered <- filter(data, ALB %in% c(25, 30, 35, 40, 45))

# Box plot 그리기 - 'WT' 및 'ALB'에 따른 'AUC' 분포 표시
ggplot(data_filtered, aes(x=WT, y=AUC)) + 
  geom_boxplot() + 
  labs(title="AUC Comparison by WT and ALB Categories", x="Weight Category (WT)", y="AUC") +
  theme_minimal() +
  facet_wrap(~ ALB, scales = "free_x", ncol = 1) + # 'ALB'에 따라 패널 분할
  scale_y_continuous(breaks=seq(5300, 5850, by=50))
