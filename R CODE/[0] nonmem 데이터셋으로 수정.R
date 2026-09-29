# 1. 작업 디렉토리 설정
setwd("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM")

# 2. 패키지 로딩
library(dplyr)
library(readr)

# 3. 원본 wide 데이터 불러오기
df <- read_csv("VALIDATION.csv", col_types = cols(.default = "c"))

# 4. 공통 변수
fixed_vars <- c("ID", "time", "SEX", "AGE", "WT", "ALB", "AST", "ALT", "SCE", "MN")
fixed_vars <- intersect(fixed_vars, names(df))

# ------------------------------------------------------------------------------
# ✅ TIME == 0 인 행 생성 (CMT 1: dummy / CMT 2: CP / CMT 3: CM)
# ------------------------------------------------------------------------------

# CMT = 1: dummy row (DV = ".", MDV = 1, AMT/ADDL/II = 실제값)
df_cmt1 <- df %>%
  filter(time == "0") %>%
  group_by(ID) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  select(all_of(fixed_vars)) %>%
  mutate(
    DV = ".",
    MDV = "1",
    CMT = "1",
    AMT = "80000", ADDL = "18", II = "24"
  )

# CMT = 2: CP 값 사용
df_cmt2 <- df %>%
  filter(time == "0") %>%
  select(all_of(fixed_vars), CP) %>%
  mutate(
    DV = ifelse(is.na(CP) | CP == ".", ".", as.character(CP)),
    MDV = ifelse(DV == ".", "1", "0"),
    CMT = "2",
    AMT = ".", ADDL = ".", II = "."
  ) %>%
  select(-CP)

# CMT = 3: CM 값 사용 (MN==2,3인 경우 DV=".", MDV=1)
df_cmt3 <- df %>%
  filter(time == "0") %>%
  group_by(ID) %>% slice_head(n = 1) %>% ungroup() %>%
  select(all_of(fixed_vars), CM) %>%
  mutate(
    DV = ifelse(MN %in% c("2", "3"), ".", as.character(CM)),
    MDV = ifelse(DV == ".", "1", "0"),
    CMT = "3",
    AMT = ".", ADDL = ".", II = "."
  ) %>%
  select(-CM)

# ------------------------------------------------------------------------------
# ✅ TIME > 0 인 관측값 (CP → CMT 2, CM → CMT 3)
# ------------------------------------------------------------------------------

# CMT = 2: CP 관측값
df_cmt2_post <- df %>%
  filter(time != "0") %>%
  select(all_of(fixed_vars), CP) %>%
  mutate(
    DV = ifelse(is.na(CP) | CP == ".", ".", as.character(CP)),
    MDV = ifelse(DV == ".", "1", "0"),
    CMT = "2",
    AMT = ".", ADDL = ".", II = "."
  ) %>%
  select(-CP)

# CMT = 3: CM 관측값 (MN==2,3이면 DV=".", MDV=1)
df_cmt3_post <- df %>%
  filter(time != "0") %>%
  select(all_of(fixed_vars), CM) %>%
  mutate(
    DV = ifelse(MN %in% c("2", "3"), ".", as.character(CM)),
    MDV = ifelse(DV == ".", "1", "0"),
    CMT = "3",
    AMT = ".", ADDL = ".", II = "."
  ) %>%
  select(-CM)

# ------------------------------------------------------------------------------
# ✅ 병합 + 정렬
# ------------------------------------------------------------------------------

df_long <- bind_rows(df_cmt1, df_cmt2, df_cmt3, df_cmt2_post, df_cmt3_post) %>%
  rename(TIME = time) %>%
  arrange(ID, as.numeric(TIME), as.integer(CMT))

# ------------------------------------------------------------------------------
# ✅ 중복 제거: CMT=2 & TIME==0 & DV=0 & MDV=0 인 행은 ID당 1줄만
# ------------------------------------------------------------------------------

df_long <- df_long %>%
  group_by(ID) %>%
  filter(!(DV == "0" & MDV == "0" & CMT == "2" & TIME == "0" & duplicated(paste(ID, TIME, DV, MDV, CMT)))) %>%
  ungroup()

# ------------------------------------------------------------------------------
# ✅ 열 순서 정리 + 저장
# ------------------------------------------------------------------------------

final_order <- c("ID", "TIME", "AMT", "ADDL", "II", "DV", "MDV", "CMT",
                 "SEX", "AGE", "WT", "ALB", "AST", "ALT", "SCE", "MN")

df_long <- df_long[, final_order]

write_csv(df_long, "VALIDATION2_FINAL.csv", na = ".")
