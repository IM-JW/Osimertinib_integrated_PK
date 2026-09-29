# 필수 패키지 로드
library(ggplot2)
library(gridExtra)

# 데이터 불러오기
data <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/AUC/AUC/AUC.csv")

# 범주형으로 변환
data$WT <- factor(data$WT)

# 첫 번째 boxplot: CP ~ WT, y축 범위: 4800 ~ 6000
plot1 <- ggplot(data, aes(x = WT, y = CP)) +
  geom_boxplot(fill = "skyblue") +
  coord_cartesian(ylim = c(4800, 6000)) +  # y축 범위 설정
  labs(title = "Boxplot of CP by WT", x = "WT (Categorical)", y = "CP") +
  theme_minimal()

# 두 번째 boxplot: CM ~ WT, y축 범위: 350 ~ 800
plot2 <- ggplot(data, aes(x = WT, y = CM)) +
  geom_boxplot(fill = "salmon") +
  coord_cartesian(ylim = c(350, 750)) +  # y축 범위 설정
  labs(title = "Boxplot of CM by WT", x = "WT (Categorical)", y = "CM") +
  theme_minimal()

# 두 그래프를 위아래로 출력
grid.arrange(plot1, plot2, ncol = 1)
