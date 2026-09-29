# 1. 공변량 범위 정의 (WT, ALB, AST, SEX 순서)
WT <- seq(40, 120, by = 10)      # 40~120 kg, 10 단위
ALB <- seq(2.5, 5.0, by = 0.5)    # 2.5~5.0 g/dL, 0.5 단위 (25~50 g/L에 해당)
AST <- seq(10, 35, by = 5)       # 10~35 IU/L, 5 단위
SEX <- c(0, 1)                   # 0 = 여자, 1 = 남자

# 2. 모든 공변량 조합 생성 (WT, ALB, AST, SEX 순서)
cov_df <- expand.grid(WT = WT, ALB = ALB, AST = AST, SEX = SEX)

# 3. 생성된 조합 리스트를 CSV 파일로 저장
# 파일 경로는 사용자 환경에 맞게 확인 후 사용하세요.
write.csv(
  cov_df,
  "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/VALIDATION/COV_list.csv",
  row.names = FALSE
)

# --- 아래는 생성된 COV_list.csv를 사용하여 시뮬레이션 파일을 만드는 과정입니다. ---

# 4. 공변량 조합 파일 불러오기
# 파일 경로는 사용자 환경에 맞게 확인 후 사용하세요.
cov_list <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/VALIDATION/COV_list.csv")

# 5. 원본 시뮬레이션 템플릿 파일 불러오기
# 파일 경로는 사용자 환경에 맞게 확인 후 사용하세요.
template <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIMULATION.csv")

# 6. 치환 대상 칼럼 지정 (WT, ALB, AST, SEX 순서)
target_cols <- c("WT", "ALB", "AST", "SEX")

# 7. 반복문으로 각 조합을 적용하여 개별 시뮬레이션 파일 저장
# 저장될 폴더 경로는 사용자 환경에 맞게 확인 후 사용하세요.
for (i in 1:nrow(cov_list)) {
  modified <- template
  for (col in target_cols) {
    # 템플릿의 해당 칼럼 값을 현재 조합의 값으로 모두 변경
    modified[[col]] <- cov_list[i, col]
  }
  # 파일명을 1000.csv, 1001.csv, ... 와 같이 생성
  output_name <- sprintf("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/%04d.csv", 999 + i)
  write.csv(modified, output_name, row.names = FALSE, quote = FALSE)
}
