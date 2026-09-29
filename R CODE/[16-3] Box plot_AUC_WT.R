# 필요한 패키지 불러오기
library(ggplot2)
library(dplyr)

# 데이터셋 불러오기
setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/AUC/AUC/")
data <- read.csv("AUC_NEW.csv")

# 'WT'를 특정 값들로 카테고리화
data$WT <- factor(data$WT, levels = c(40, 50, 60, 70, 80, 90, 100, 110, 120), 
                  labels = c("40", "50", "60", "70", "80", "90", "100", "110", "120"))

# 'SEX'를 factor로 변환하고 'Male', 'Female'로 레이블 지정
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 2.5, 3.0, 3.5, 4.0, 4.5인 데이터만 필터링
data_filtered <- dplyr::filter(data, ALB %in% c(2.5, 3.0, 3.5, 4.0, 4.5, 5.0))

# Box plot 그리기 - 'WT' 범주에 따른 'AUC' 분포 표시, 각 범주별 다른 색상 지정
plot <- ggplot(data_filtered, aes(x=WT, y=AUC, fill=WT)) + 
  geom_boxplot() + 
  labs(title="", x="Weight (Kg) ", y="AUCss (ng*h/mL) ") +
  theme_minimal() +
  scale_y_continuous(breaks=seq(5350, 5820, by=50), limits=c(5300, 5850)) + 
  scale_fill_brewer(palette="Paired") +  # 'WT' 범주별로 다른 색상 할당
  theme(axis.title.x = element_text(size = 16),   # x축 타이틀 크기 설정
        axis.title.y = element_text(size = 16))   # y축 타이틀 크기 설정

# Plot 화면에 출력
print(plot)

# Plot을 PNG 파일로 저장
ggsave("AUC_by_WT_120.png", plot, width = 10, height = 8, dpi = 300)
