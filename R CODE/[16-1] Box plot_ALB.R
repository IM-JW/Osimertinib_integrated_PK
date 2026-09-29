library(ggplot2)
library(dplyr)

# 경로 지정 (입력/출력 분리 가능)
infile  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/AUC/P/AUC_P.csv"
outfile <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/AUC/P/AUC_P_ALB_SEX.png"

dat <- read.csv(infile, check.names = FALSE)

# SEX 레이블(데이터가 0=Female, 1=Male일 때)
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Male", "Female"))


# ALB 필터 및 축 순서 고정
alb_levels <- c(25, 30, 35, 40, 45, 50)  # 주석과 일치
df <- dat %>%
  filter(ALB %in% alb_levels) %>%
  mutate(ALB = factor(ALB, levels = alb_levels))

p <- ggplot(df, aes(x = ALB, y = AUC, fill = SEX)) +
  geom_boxplot() +
  labs(title = "", x = "ALB (g/dL)", y = "AUCss (ng*h/mL)") +
  scale_fill_manual(values = c("Female"="pink", "Male"="skyblue")) +
  theme_minimal() +
  coord_cartesian(ylim = c(4500, 7000)) +
  scale_y_continuous(breaks = seq(4500, 7000, by = 100)) +
  theme(axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16))

print(p)
# ggsave(outfile, plot = p, width = 10, height = 6, dpi = 300)
