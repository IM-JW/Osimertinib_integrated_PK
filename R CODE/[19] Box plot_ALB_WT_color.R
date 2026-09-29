# 필요한 패키지 불러오기
setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/")



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

# Plot 생성 및 색상 지정
plot <- ggplot(data_filtered, aes(x=WT, y=AUC)) + 
  geom_boxplot(fill="skyblue") +  # BOX 색상을 skyblue로 지정
  labs(title="AUC Comparison by WT Categories for Specific ALB Values", x="Weight", y="AUC") +
  theme_minimal() +
  scale_y_continuous(breaks=seq(5350, 5820, by=50), limits=c(5300, 5850))  # Y축 눈금과 범위 조정

# Plot 화면에 출력
print(plot)

# Plot을 PNG 파일로 저장
ggsave("AUC_by_WT_Categories.png", plot, width = 10, height = 8, dpi = 300)






############# BOX 마다 색 다르게 하는 코드 아래 ############

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

# Box plot 그리기 - 'WT' 범주에 따른 'AUC' 분포 표시, 각 범주별 다른 색상 지정
plot <- ggplot(data_filtered, aes(x=WT, y=AUC, fill=WT)) + 
  geom_boxplot() + 
  labs(title="AUC Comparison by WT Categories for Specific ALB Values", x="Weight Category (WT)", y="AUC") +
  theme_minimal() +
  scale_y_continuous(breaks=seq(5350, 5820, by=50), limits=c(5300, 5850)) + 
  scale_fill_brewer(palette="Paired") # 'WT' 범주별로 다른 색상 할당

# Plot 화면에 출력
print(plot)

# Plot을 PNG 파일로 저장
#ggsave("AUC_by_WT_Categories_colored.png", plot, width = 10, height = 8, dpi = 300)
