# 필요한 패키지 불러오기
install.packages("ggridges")

library(ggplot2)
library(dplyr)
library(ggridges) # 리지 플롯 생성을 위한 패키지

# 데이터셋 불러오기
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환
data$WT <- cut(data$WT, breaks = seq(40, 110, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 100, by = 10), seq(50, 110, by = 10), sep = "-"))

# 'SEX'를 factor로 변환
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 25, 30, 35, 40, 45인 데이터만 필터링
data_filtered <- filter(data, ALB %in% c(25, 30, 35, 40, 45))

# 리지 플롯 그리기 - 'WT' 및 'ALB'에 따른 'AUC' 분포 표시
ggplot(data_filtered, aes(x = AUC, y = ALB, fill = factor(ALB))) + 
  geom_density_ridges() +
  labs(title="AUC Distribution by WT and ALB Categories", x="AUC", y="ALB") +
  theme_ridges() +
  scale_fill_brewer(palette="Set3")
