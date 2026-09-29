# 필요한 패키지 불러오기
library(ggplot2)
library(dplyr)

setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/AUC/AUC")
# 데이터셋 불러오기
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/AUC/AUC/AUC_NEW.csv")

# 'WT'를 범주형 변수로 변환
data$WT <- cut(data$WT, breaks = seq(40, 120, by = 10), include.lowest = TRUE, right = FALSE,
               labels = paste(seq(40, 110, by = 10), seq(50, 120, by = 10), sep = "-"))

# 'SEX'를 factor로 변환하고 'Male', 'Female'로 레이블 지정
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 'ALB' 값이 2.5, 3.0, 3.5, 4.0, 4.5인 데이터만 필터링
data_filtered <- filter(data, ALB %in% c(2.5, 3.0, 3.5, 4.0, 4.5))

# 필터링된 데이터 확인
print(table(data_filtered$ALB))

# Box plot 그리기
p <- ggplot(data_filtered, aes(x=factor(ALB), y=AUC, fill=SEX)) + 
  geom_boxplot() + 
  labs(title="AUCss by ALB for SEX", x="ALB", y="AUC") +
  scale_fill_manual(values=c("Female"="pink", "Male"="skyblue")) +
  theme_minimal() +
  facet_wrap(~ALB, scales = "free") +
  coord_cartesian(ylim = c(5450, 5750)) +
  scale_y_continuous(breaks=seq(5450, 5750, by=50))

# 그래프 미리보기
print(p)

# 그래프를 PNG 파일로 저장
ggsave("AUCss_by_ALB_for_SEX.png", plot = p, width = 10, height = 6, dpi = 300)
