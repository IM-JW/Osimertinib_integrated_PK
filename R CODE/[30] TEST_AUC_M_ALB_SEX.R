
### ===== Metabolite only =====
# Parent compartment는 sex effect가 없음!! 


# 패키지
library(ggplot2)
library(dplyr)

# ===== 경로 지정 =====
infile  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/VALI/AUC/P/AUC_P.csv"
outdir  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/PLOT"
outfile <- file.path(outdir, "VALI_AUC_P_ALB_SEX.png")

if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# ===== 데이터 로드 =====
dat <- read.csv(infile, check.names = FALSE)

# ===== SEX 처리 (0=Female, 1=Male) =====
if (is.numeric(dat$SEX) || is.integer(dat$SEX)) {
  dat$SEX <- factor(dat$SEX, levels = c(0, 1), labels = c("Female", "Male"))
} else {
  dat$SEX <- as.character(dat$SEX)
  dat$SEX <- ifelse(tolower(dat$SEX) %in% c("0","f","female"), "Female",
                    ifelse(tolower(dat$SEX) %in% c("1","m","male"), "Male", dat$SEX))
  dat$SEX <- factor(dat$SEX, levels = c("Female","Male"))
}

# ===== ALB 레벨 고정 =====
alb_levels <- c(25, 30, 35, 40, 45, 50)
df <- dat %>%
  filter(ALB %in% alb_levels) %>%
  mutate(ALB = factor(ALB, levels = alb_levels))

# ===== 플롯 객체 =====
p <- ggplot(df, aes(x = ALB, y = AUC, fill = SEX)) +
  geom_boxplot(outlier.size = 0.8, width = 0.7) +
  labs(
    title = "",
    x = "ALB (g/dL)",     # 필요 시 g/L로 변경
    y = "AUCss (ng·h/mL)"
  ) +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "skyblue")) +
  theme_minimal(base_size = 13) +
  coord_cartesian(ylim = c(4600, 6650)) +
  scale_y_continuous(breaks = seq(4600, 6650, by = 200)) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    legend.title  = element_blank()
  )

# ===== 미리보기 + 저장 =====
preview <- TRUE  # 미리보기 창을 띄우려면 TRUE

if (preview) {
  # RStudio면 아래 한 줄만으로도 미리보기 가능
  print(p)
  
  # Windows 전용: 별도 큰 창으로 미리보기 (R GUI/터미널에서도 잘 보임)
  if (.Platform$OS.type == "windows") {
    windows(width = 12, height = 7)  # 폭 12in, 높이 7in 미리보기
    print(p)
  }
}

# 저장
ggsave(outfile, plot = p, width = 10, height = 6, dpi = 300)
message(sprintf("Saved plot to: %s", outfile))

# ===== (옵션) 인터랙티브 미리보기 =====
# library(plotly)
# plotly::ggplotly(p)
