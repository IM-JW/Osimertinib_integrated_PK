### ===== Metabolite only =====
# Parent compartment는 sex effect가 없음!!

# 패키지
library(ggplot2)
library(dplyr)

# ===== 경로 지정 =====
infile  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/PLOT/AUC_M.csv"
outdir  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/PLOT"
outfile <- file.path(outdir, "AUC_P_WT_SET.png")

if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# ===== 데이터 로드 =====
dat <- read.csv(infile, check.names = FALSE)

# ===== SET 처리 (라벨: TEST, VALIDATION) =====
# 허용되는 값 예: test, TEST, validation, VALIDATION, valid 등
dat$SET <- as.character(dat$SET)
dat$SET <- trimws(toupper(dat$SET))
dat$SET[dat$SET %in% c("VAL", "VALID", "VALIDATE", "VALIDATION SET")] <- "VALIDATION"

ok_levels <- c("TEST", "VALIDATION")
if (!all(unique(dat$SET) %in% ok_levels)) {
  bad_vals <- setdiff(unique(dat$SET), ok_levels)
  warning(sprintf("SET 컬럼에 허용 밖 값이 있습니다: %s", paste(bad_vals, collapse = ", ")))
}
dat$SET <- factor(dat$SET, levels = ok_levels)

# ===== WT 레벨 고정 =====
# 필요 시 구간 변경 가능
wt_levels <- c(40, 50, 60, 70, 80, 90, 100, 110)
df <- dat %>%
  filter(WT %in% wt_levels) %>%
  mutate(WT = factor(WT, levels = wt_levels))

# ===== 플롯 객체 =====
p <- ggplot(df, aes(x = WT, y = AUC, fill = SET)) +
  geom_boxplot(outlier.size = 0.8, width = 0.7) +
  labs(
    title = "",
    x = "WT (kg)",
    y = "AUCss (ng·h/mL)",
    fill = "Set"
  ) +
  scale_fill_manual(values = c("TEST" = "grey70", "VALIDATION" = "steelblue")) +
  theme_minimal(base_size = 13) +
  coord_cartesian(ylim = c(4600, 6500)) +
  scale_y_continuous(breaks = seq(4600, 6500, by = 100)) +
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    legend.title  = element_text(size = 12),
    legend.text   = element_text(size = 11)
  )

# ===== 미리보기 + 저장 =====
preview <- TRUE

if (preview) {
  print(p)
  if (.Platform$OS.type == "windows") {
    windows(width = 12, height = 7)
    print(p)
  }
}

ggsave(outfile, plot = p, width = 10, height = 6, dpi = 300)
message(sprintf("Saved plot to: %s", outfile))

# ===== (옵션) 인터랙티브 미리보기 =====
# library(plotly)
# plotly::ggplotly(p)
