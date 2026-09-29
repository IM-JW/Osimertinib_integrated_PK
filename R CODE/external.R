# 필요한 라이브러리 로드
library(ggplot2)
library(dplyr)

# 첫 번째 데이터 불러오기
data1 <- read.csv("C:/Users/jack/OneDrive - 연세대학교 (Yonsei University)/바탕 화면/bortezomib_simul/1.5onceweek/1.5_AUC.csv")

# 두 번째 데이터 불러오기
data2 <- read.csv("C:/Users/jack/OneDrive - 연세대학교 (Yonsei University)/바탕 화면/bortezomib_simul/1.5onceweek/Dataset 4.csv")

# 첫 번째 데이터 필터링 (TIME이 0부터 24)
data1_filtered <- data1 %>% filter(TIME >= 0 & TIME <= 24)

# 두 번째 데이터 필터링 (TIME이 0부터 24)
data2_filtered <- data2 %>% filter(TIME >= 0 & TIME <= 24)

# 첫 번째 데이터의 TIME별 중앙값 및 5~95% 신뢰구간 계산
summary_data1 <- data1_filtered %>%
  group_by(TIME) %>%
  summarise(
    median_DV = median(DV),
    lower = quantile(DV, 0.05),
    upper = quantile(DV, 0.95)
  )

# 두 번째 데이터의 TIME별 중앙값 계산
summary_data2 <- data2_filtered %>%
  group_by(TIME) %>%
  summarise(
    median_DV = median(DV)
  )

# 첫 번째 데이터의 신뢰구간 및 중앙값 그래프 생성
p <- ggplot(summary_data1, aes(x = TIME)) +
  geom_line(aes(y = median_DV), color = "blue", linewidth = 1) +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "blue", alpha = 0.2) +
  labs(title = "External validation", x = "Time (h)", y = "Bortezomib concentration (ng/mL)") +
  theme_minimal() +
  ylim(0, 60)

# 두 번째 데이터의 중앙값을 빨간색 선으로 추가
p <- p + geom_line(data = summary_data2, aes(x = TIME, y = median_DV), color = "red", linewidth = 1, linetype = "dashed")

# PDF 장치 열기
pdf(file = "C:/Users/jack/OneDrive - 연세대학교 (Yonsei University)/바탕 화면/bortezomib_simul/1.5onceweek/Combined_DV_Plot.pdf", 
    width = 10, 
    height = 6)

# 플롯 그리기
print(p)

# PDF 장치 닫기
dev.off()
