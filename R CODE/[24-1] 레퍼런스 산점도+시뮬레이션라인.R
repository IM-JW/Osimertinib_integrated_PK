library(ggplot2)
library(gridExtra)
library(readxl)

# 엑셀 파일 경로
file_path <- "C:/Users/Clinical/Desktop/MBMA/osimertinib/시뮬레이션 범위 레퍼런스.xlsx"

# 엑셀 파일을 읽어옵니다
data <- read_excel(file_path, sheet = "Sheet1")

# 'Cmax (ng/mL)', 'AUCss (ng·h/mL)', 'Cmin (ng/mL)' 열이 숫자형이 아니므로 숫자형으로 변환합니다
data$`Cmax (ng/mL)` <- as.numeric(data$`Cmax (ng/mL)`)
data$`AUCss (ng·h/mL)` <- as.numeric(data$`AUCss (ng·h/mL)`)
data$`Cmin (ng/mL)` <- as.numeric(data$`Cmin (ng/mL)`)

# 'Study' 열을 범주형으로 변환합니다
data$Study <- as.factor(data$Study)

# 직접 지정한 표준 편차
cmax_sd <- 10.27 # 예시로 임의의 값을 지정합니다
auc_sd <- 139.16 # 예시로 임의의 값을 지정합니다
cmin_sd <- 6.29   # 예시로 임의의 값을 지정합니다

# 산점도를 그리고 각 y축에 참조선과 표준편차를 추가하며 x축을 범주형으로 설정합니다
p1 <- ggplot(data, aes(x = Study, y = `Cmax (ng/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 272.31, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 272.31 + cmax_sd, linetype = "dotted", color = "blue") +
  geom_hline(yintercept = 272.31 - cmax_sd, linetype = "dotted", color = "blue") +
  annotate("segment", x = 7.5, xend = 7, y = 390, yend = 390, color = "red", linetype = "dashed") +
  annotate("text", x = 7.5, y = 390, label = "Simulated Cmax", hjust = 0, color = "red", size = 3) +
  annotate("segment", x = 7.5, xend = 7, y = 370, yend = 370, color = "blue", linetype = "dotted") +
  annotate("text", x = 7.5, y = 370, label = "SD", hjust = 0, color = "blue", size = 3) +
  ylim(200, 400) +
  labs(title = "Cmax (ng/mL) by Study") +
  theme(plot.margin = margin(10, 50, 10, 10))

p2 <- ggplot(data, aes(x = Study, y = `AUCss (ng·h/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 5580, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 5580 + auc_sd, linetype = "dotted", color = "blue") +
  geom_hline(yintercept = 5580 - auc_sd, linetype = "dotted", color = "blue") +
  annotate("segment", x = 7.5, xend = 7, y = 7400, yend = 7400, color = "red", linetype = "dashed") +
  annotate("text", x = 7.5, y = 7400, label = "Simulated ACU", hjust = 0, color = "red", size = 3) +
  annotate("segment", x = 7.5, xend = 7, y = 7200, yend = 7200, color = "blue", linetype = "dotted") +
  annotate("text", x = 7.5, y = 7200, label = "SD", hjust = 0, color = "blue", size = 3) +
  ylim(4500, 7500) +
  labs(title = "AUCss (ng·h/mL) by Study") +
  theme(plot.margin = margin(10, 50, 10, 10))

p3 <- ggplot(data, aes(x = Study, y = `Cmin (ng/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 205.59, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 205.59 + cmin_sd, linetype = "dotted", color = "blue") +
  geom_hline(yintercept = 205.59 - cmin_sd, linetype = "dotted", color = "blue") +
  annotate("segment", x = 7.5, xend = 7, y = 125, yend = 125, color = "red", linetype = "dashed") +
  annotate("text", x = 7.5, y = 125, label = "Simulated Cmin", hjust = 0, color = "red", size = 3) +
  annotate("segment", x = 7.5, xend = 7, y = 110, yend = 110, color = "blue", linetype = "dotted") +
  annotate("text", x = 7.5, y = 110, label = "SD", hjust = 0, color = "blue", size = 3) +
  ylim(100, 250) +
  labs(title = "Cmin (ng/mL) by Study") +
  theme(plot.margin = margin(10, 50, 10, 10))  # 오른쪽에 충분한 여백 추가

# 여러 개의 산점도를 한 화면에 출력
grid.arrange(p1, p2, p3, ncol = 1)

setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib")

# PNG 파일로 저장
ggsave("REF_plot.png", arrangeGrob(p1, p2, p3, ncol = 1), width = 8, height = 12)