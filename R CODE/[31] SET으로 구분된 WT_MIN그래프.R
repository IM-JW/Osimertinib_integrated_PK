# -----------------------------
# 패키지 로드
# -----------------------------
suppressPackageStartupMessages({
  if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
  library(tidyverse)
})

# -----------------------------
# 경로 설정
# -----------------------------
input_dir  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/TEST/MIN"
output_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/PLOT"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# -----------------------------
# 파일 선택 및 데이터 로드
# -----------------------------
files <- list.files(input_dir, pattern = "\\.(csv|tsv|tab|txt)$", full.names = TRUE, ignore.case = TRUE)
stopifnot("입력 파일이 없습니다." = length(files) > 0)
candidate <- c(grep("CMIN_P", files, value = TRUE, ignore.case = TRUE), files)[1]

read_any <- function(path){
  ext <- tolower(tools::file_ext(path))
  if (ext == "csv") readr::read_csv(path, guess_max = 100000, show_col_types = FALSE)
  else readr::read_tsv(path, guess_max = 100000, show_col_types = FALSE)
}
dat <- read_any(candidate)
names(dat) <- toupper(names(dat))

# -----------------------------
# 컬럼 매핑
# -----------------------------
pick_col <- function(df, cand) { 
  hit <- intersect(cand, names(df)); 
  if (length(hit)==0) return(NULL); 
  df[[hit[1]]] 
}
WT   <- pick_col(dat, c("WT","WTKG","WEIGHT"))
PRED <- pick_col(dat, c("PRED","IPRED","CMIN_P","CPRED","CMAX_P"))
stopifnot("WT 또는 PRED 계열 컬럼이 없습니다." = !is.null(WT) && !is.null(PRED))

df <- tibble(WT = as.numeric(WT), PRED = as.numeric(PRED)) |> drop_na()

# -----------------------------
# 구간화 (40~130까지 10kg bin)
# -----------------------------
brk <- seq(40, 130, by = 10)   # 40–50, …, 120–130 포함
df <- df |> mutate(WT_BIN = cut(WT, breaks = brk, include.lowest = TRUE, right = FALSE))

# -----------------------------
# 라벨: range → 시작값만
# -----------------------------
bin_labels <- sapply(levels(df$WT_BIN), function(x) {
  as.character(as.numeric(gsub("\\[|\\)|\\]", "", strsplit(x, ",")[[1]][1])))
})

# -----------------------------
# 색상 팔레트 (rainbow 톤)
# -----------------------------
my_colors <- c(
  "#F8766D", # 레드-핑크
  "#C49A00", # 머스타드
  "#53B400", # 라임그린
  "#00C094", # 청록
  "#00B6EB", # 블루
  "#A58AFF", # 퍼플
  "#FB61D7", # 핑크
  "#00BA38", # 녹색
  "#E76BF3"  # 추가 보라색 (120–130 bin용)
)

# -----------------------------
# 플롯 생성
# -----------------------------
p <- ggplot(df, aes(x = WT_BIN, y = PRED, fill = WT_BIN)) +
  geom_boxplot(outlier.alpha = 0.3) +
  labs(title = "PRED by Weight (binned)",
       x = "Weight (kg)", 
       y = "Cmin(ng/mL)", 
       fill = "Weight (kg)") +
  scale_x_discrete(labels = bin_labels) +
  scale_fill_manual(values = my_colors[1:length(levels(df$WT_BIN))],
                    labels = bin_labels) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))

# -----------------------------
# 미리보기
# -----------------------------
if (interactive()) {
  print(p)
} else {
  grDevices::windows(width = 8, height = 5)
  print(p)
  utils::flush.console()
  invisible(readline("미리보기 창을 닫으려면 Enter 키를 누르세요..."))
  dev.off()
}

# -----------------------------
# 저장 (PNG + PDF)
# -----------------------------
ts <- format(Sys.time(), "%Y%m%d_%H%M%S")
png_path <- file.path(output_dir, sprintf("WT_PRED_boxplot_%s.png", ts))
pdf_path <- file.path(output_dir, sprintf("WT_PRED_boxplot_%s.pdf", ts))
ggsave(png_path, plot = p, width = 8, height = 5, dpi = 320)
ggsave(pdf_path, plot = p, width = 8, height = 5)

# 저장된 파일 바로 열기 (선택)
try(utils::browseURL(png_path), silent = TRUE)
