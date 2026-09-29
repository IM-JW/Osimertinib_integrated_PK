# 필요한 패키지 불러오기
library(ggplot2)
library(dplyr)

# 데이터셋 불러오기
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER2/sim2/SIM/AUC/AUC/AUC_plot/AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환
data$WT <- cut(data$WT, breaks = seq(40, 110, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 100, by = 10), seq(50, 110, by = 10), sep = "-"))

# 'SEX'를 factor로 변환
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 25, 30, 35, 40, 45인 데이터만 필터링
data_filtered <- filter(data, ALB %in% c(25, 30, 35, 40, 45))

# 산점도 그리기 - 'WT', 'ALB'에 따른 'AUC' 분포 중첩 표시
plot <- ggplot(data_filtered, aes(x=WT, y=AUC, color=factor(ALB))) + 
  geom_point(alpha=0.6) +  # 산점도
  stat_summary(fun.y=mean, geom="line", aes(group=factor(ALB)), color="black") +  # 각 'ALB' 범주별 평균 선
  labs(title="AUC Distribution by WT and ALB Categories", x="Weight Category (WT)", y="AUC", color="ALB") +
  theme_minimal() +
  theme(legend.position="right")  # 범례 위치 조정

# Plot 화면에 출력
print(plot)

# Plot을 PNG 파일로 저장
ggsave("AUC_Distribution_by_WT_and_ALB.png", plot, width = 10, height = 8, dpi = 300)
