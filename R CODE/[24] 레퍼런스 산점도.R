# 필요한 패키지를 로드합니다
library(readxl)
library(ggplot2)
library(gridExtra)

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

# 산점도를 그리고 각 y축에 참조선을 추가하며 x축을 범주형으로 설정합니다
p1 <- ggplot(data, aes(x = Study, y = `Cmax (ng/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 272.31, linetype="dashed", color = "red") +
  scale_y_continuous(limits = c(150, 400)) +
  labs(title = "Cmax (ng/mL) ") +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))

p2 <- ggplot(data, aes(x = Study, y = `AUCss (ng·h/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 5611, linetype="dashed", color = "red") +
  scale_y_continuous(limits = c(4500, 7500)) +
  labs(title = "AUCss (ng·h/mL)") +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))

p3 <- ggplot(data, aes(x = Study, y = `Cmin (ng/mL)`)) + 
  geom_point() +
  geom_hline(yintercept = 195, linetype="dashed", color = "red") +
  scale_y_continuous(limits = c(100, 350)) +
  labs(title = "Cmin (ng/mL)") +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))

# 여러 개의 산점도를 한 화면에 출력
plots <- grid.arrange(p1, p2, p3, ncol = 1)

# 그래프를 PNG 파일로 저장 (단일 그래프 크기를 300x300 픽셀로 설정)
ggsave("C:/Users/Clinical/Desktop/MBMA/osimertinib/plots.png", plots, width = 6, height = 18, units = "in", dpi = 100)
