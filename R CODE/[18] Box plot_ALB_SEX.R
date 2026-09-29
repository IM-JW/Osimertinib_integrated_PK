# 필요한 패키지 불러오기
setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/")

library(ggplot2)
library(dplyr)

# 데이터셋 불러오기
data <- read.csv("AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환
data$WT <- cut(data$WT, breaks = seq(40, 110, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 100, by = 10), seq(50, 110, by = 10), sep = "-"))

# 'SEX'를 factor로 변환하고 'Male', 'Female'로 레이블 지정
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 25, 30, 35, 40, 45인 데이터만 필터링
data_filtered <- filter(data, ALB %in% c(25, 30, 35, 40, 45))

# Box plot 그리기 - 'SEX'에 따른 'AUC' 분포 표시, y축 눈금 조정
plot <- ggplot(data_filtered, aes(x=factor(ALB), y=AUC, fill=SEX)) + 
  geom_boxplot() + 
  labs(title="", x="ALB", y="AUC") +
  scale_fill_manual(values=c("Female"="pink", "Male"="lightblue")) + # 성별에 따른 컬러 지정
  theme_minimal() +
  coord_cartesian(ylim = c(5450, 5750)) +
  scale_y_continuous(breaks=seq(5400, 5800, by=40)) # Y축을 40단위로 조정

# Plot 화면에 출력
print(plot)

# Plot을 PNG 파일로 저장
ggsave("AUC_Boxplot_by_SEX_and_ALB_pink.png", plot, width = 8, height = 6, dpi = 300)
