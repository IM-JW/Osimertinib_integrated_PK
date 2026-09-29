# 필요한 패키지 불러오기
library(ggplot2)
library(dplyr)

# 데이터셋 불러오기
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환
data$WT <- cut(data$WT, breaks = seq(40, 110, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 100, by = 10), seq(50, 110, by = 10), sep = "-"))

# 'SEX'를 factor로 변환하고 'Male', 'Female'로 레이블 지정
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' <= 35에 해당하는 데이터 필터링 및 Box Plot 생성
data_sub1 <- filter(data, ALB <= 35)
ggplot(data_sub1, aes(x=SEX, y=AUC, fill=WT)) + 
  geom_boxplot() + 
  labs(title="AUC for ALB <= 35", x="Sex", y="AUC") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

# 'ALB' == 40에 해당하는 데이터 필터링 및 Box Plot 생성
data_sub2 <- filter(data, ALB == 40)
ggplot(data_sub2, aes(x=SEX, y=AUC, fill=WT)) + 
  geom_boxplot() + 
  labs(title="AUC for ALB = 40", x="Sex", y="AUC") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

# 'ALB' >= 45에 해당하는 데이터 필터링 및 Box Plot 생성
data_sub3 <- filter(data, ALB >= 45)
ggplot(data_sub3, aes(x=SEX, y=AUC, fill=WT)) + 
  geom_boxplot() + 
  labs(title="AUC for ALB >= 45", x="Sex", y="AUC") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()
