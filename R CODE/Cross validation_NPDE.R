# =========================
# NPDE robust pipeline (no unsupported args; PD fallback)
# =========================

# --- 패키지 ---
if (!requireNamespace("npde", quietly=TRUE)) install.packages("npde")
if (!requireNamespace("data.table", quietly=TRUE)) install.packages("data.table")
library(npde); library(data.table)

# --- 경로 (너가 준 VALI/RESULT/P 기준) ---
obs_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/DV/P"
sim_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/VALI/RESULT/P"
out_dir <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/INTER/SIMDV/NPDE"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive=TRUE, showWarnings=FALSE)
logf <- function(...) { cat(sprintf("[%s] %s\n", format(Sys.time(), "%H:%M:%S"), sprintf(...))); flush.console() }

# --- 관찰 파일 선택 ---
obs_file <- if (file.exists(file.path(obs_dir, "DV_VALI_P.csv"))) {
  file.path(obs_dir, "DV_VALI_P.csv")
} else {
  cs <- list.files(obs_dir, pattern="\\.csv$", full.names=TRUE)
  if (length(cs)==0) stop("관찰 CSV(DV_VALI_P.csv)를 찾지 못했습니다.")
  cs[1]
}
logf("관찰파일: %s", obs_file)

# --- 관찰 로드 & 표준화(ID,TIME,DV,MDV) ---
obs_head <- fread(obs_file, nrows=0)
uc <- toupper(names(obs_head))
idx_id  <- which(uc %in% c("ID"))[1]
idx_x   <- which(uc %in% c("TIME","T","X","TIME_AFTER_DOSE"))[1]
idx_y   <- which(uc %in% c("DV","Y","CONC","VALUE"))[1]
idx_mdv <- which(uc %in% c("MDV"))[1]
if (is.na(idx_id) || is.na(idx_x) || is.na(idx_y)) stop("관찰파일에 ID/TIME/DV 열이 필요합니다.")

obs_all <- fread(obs_file, na.strings=c(".", "NA", "", "NULL"))
setDT(obs_all)
setnames(obs_all, c(idx_id, idx_x, idx_y), c("ID","TIME","DV"))
if (!is.na(idx_mdv)) setnames(obs_all, idx_mdv, "MDV")

# MDV==0만 분석
obs_eff <- if ("MDV" %in% names(obs_all)) obs_all[MDV==0] else obs_all
obs_eff[, `:=`(ID=as.integer(ID), TIME=as.numeric(TIME), DV=as.numeric(DV))]
obs_eff <- obs_eff[!is.na(ID) & is.finite(TIME) & is.finite(DV)]
obs_eff[, ORD := .I]
setkey(obs_eff, ID, TIME)
n_eff <- nrow(obs_eff)
logf("관찰 유효행 수: %d", n_eff)

# --- 시뮬 파일 목록 (SIM1000~1999) ---
sim_files <- sprintf(file.path(sim_dir, "SIM%04d_P.csv"), 1000:1999)
sim_files <- sim_files[file.exists(sim_files)]
if (!length(sim_files)) stop("SIM1000_P.csv~SIM1999_P.csv를 찾지 못했습니다.")
n_files <- length(sim_files)
logf("시뮬 파일 수: %d", n_files)

# --- 유틸: 시뮬 파일 1개를 관찰 키로 정렬해 DV 벡터 반환 ---
read_align_sim <- function(f, obs_key_dt) {
  sj <- fread(f, na.strings=c(".", "NA", "", "NULL"))
  if (nrow(sj)==0) stop(sprintf("빈 파일: %s", basename(f)))
  nm <- toupper(names(sj))
  mdv_col <- if ("MDV" %in% nm) which(nm=="MDV")[1] else NA_integer_
  if (!is.na(mdv_col)) sj <- sj[sj[[mdv_col]]==0 | is.na(sj[[mdv_col]])]
  
  id_idx   <- which(nm=="ID")[1]
  time_idx <- which(nm %in% c("TIME","T","X","TIME_AFTER_DOSE"))[1]
  dv_idx   <- which(nm %in% c("DV","Y","CONC","VALUE"))[1]
  if (is.na(id_idx) || is.na(time_idx) || is.na(dv_idx)) {
    stop(sprintf("필수 열(ID/TIME/DV) 부족: %s", basename(f)))
  }
  
  setnames(sj, c(id_idx, time_idx, dv_idx), c("ID","TIME","DV"))
  setDT(sj)
  sj[, `:=`(ID=as.integer(ID), TIME=as.numeric(TIME), DV=as.numeric(DV))]
  sj <- sj[!is.na(ID) & is.finite(TIME) & is.finite(DV)]
  setkey(sj, ID, TIME)
  
  ali <- sj[obs_key_dt, on=.(ID,TIME)]
  if (nrow(ali) != nrow(obs_key_dt)) stop(sprintf("행수 불일치: %s", basename(f)))
  as.numeric(ali$DV)
}

# --- (선택) 분산 진단: 퇴화 여부 파악만 함(필터링은 안 함) ---
logf("분산 진단(필터링 안 함) 시작...")
obs_key <- obs_eff[, .(ID, TIME)]
mean_vec <- numeric(n_eff); M2_vec <- numeric(n_eff); k <- 0L
for (i in seq_along(sim_files)) {
  y <- read_align_sim(sim_files[i], obs_key)
  idx <- which(is.finite(y))
  if (length(idx)>0) {
    k <- k + 1L
    delta <- y[idx] - mean_vec[idx]
    mean_vec[idx] <- mean_vec[idx] + delta / k
    M2_vec[idx]   <- M2_vec[idx] + delta * (y[idx] - mean_vec[idx])
  }
  if (i %% 100 == 0 || i==length(sim_files)) logf("  진행률 %d/%d", i, length(sim_files))
}
if (k<2L) logf("주의: 유효 복제수가 2 미만입니다.")
var_vec <- if (k>=2L) M2_vec / (k-1) else rep(0, n_eff)
degenerate <- (all(var_vec==0 | is.na(var_vec)))
logf("분산>0 포인트 수: %d / %d", sum(var_vec>0, na.rm=TRUE), n_eff)
fwrite(data.table(ORD=obs_eff$ORD, ID=obs_eff$ID, TIME=obs_eff$TIME, Var=var_vec),
       file.path(out_dir, "variance_check.csv"))

# --- 스택 생성(관찰 전 행 사용; 필터 없음) ---
stack_file <- file.path(out_dir, "SIM_STACK.csv")
if (file.exists(stack_file)) file.remove(stack_file)
fwrite(data.table(ID=integer(), TIME=double(), YSIM=double()), stack_file, col.names=TRUE)

chunk_size <- 50
for (i in seq(1, n_files, by=chunk_size)) {
  rng <- i:min(i+chunk_size-1, n_files)
  logf("스택 생성: %d..%d / %d", rng[1], rng[length(rng)], n_files)
  buf <- vector("list", length(rng))
  for (k in seq_along(rng)) {
    f <- sim_files[rng[k]]
    y <- read_align_sim(f, obs_key)
    ali <- data.table(ID=obs_eff$ID, TIME=obs_eff$TIME, YSIM=y, ORD=obs_eff$ORD)[order(ORD), .(ID,TIME,YSIM)]
    if (nrow(ali) != n_eff) stop(sprintf("스택 행수 불일치: %s", basename(f)))
    if (any(!is.finite(ali$YSIM))) stop(sprintf("NA/Inf 발견: %s", basename(f)))
    buf[[k]] <- ali
  }
  fwrite(rbindlist(buf, use.names=TRUE), stack_file, append=TRUE, col.names=FALSE)
}
logf("스택 완료: %s", stack_file)

# --- 관찰/시뮬 data.frame 준비 + 배수성/자동트림 ---
obs_used <- obs_eff[, .(ID, TIME, DV)]
obs_used[, `:=`(ID=as.integer(ID), TIME=as.numeric(TIME), DV=as.numeric(DV))]
sim_df <- fread(stack_file)
setnames(sim_df, names(sim_df), c("ID","TIME","YSIM"))
sim_df[, `:=`(ID=as.integer(ID), TIME=as.numeric(TIME), YSIM=as.numeric(YSIM))]

nobs <- nrow(obs_used)
actual_rows <- nrow(sim_df)
nsim_expected <- n_files
expected_rows <- nobs * nsim_expected

if (actual_rows != expected_rows) {
  rem <- actual_rows %% nobs
  warning(sprintf("[WARN] 스택 행수 불일치: 기대 %d vs 실제 %d → 마지막 %d행 트림", expected_rows, actual_rows, rem))
  if (rem > 0) sim_df <- sim_df[1:(actual_rows - rem)]
}
nsim <- nrow(sim_df) %/% nobs
logf("복제 수: %d, 관찰 수: %d, 총 스택 행: %d", nsim, nobs, nrow(sim_df))
stopifnot(nrow(sim_df) == nobs * nsim)

# --- (선택) 분산≈0이면 미세 지터 추가(수치 안정성) ---
add_jitter <- degenerate
if (add_jitter) {
  s <- median(abs(sim_df$YSIM), na.rm=TRUE); if (!is.finite(s) || s==0) s <- 1
  set.seed(1234)
  sim_df$YSIM <- sim_df$YSIM + rnorm(nrow(sim_df), sd = 1e-9 * s)
  logf("분산≈0 감지 → YSIM에 극미 지터 추가 완료")
}

# --- NPDE 시도 (지원되지 않는 인자 사용 안 함) + PD 폴백 ---
npde_obj <- NULL
npde_ok <- FALSE
npde_err <- NULL

try({
  npde_obj <- autonpde(
    namobs = as.data.frame(obs_used),
    namsim = as.data.frame(sim_df),
    iid = "ID", ix = "TIME", iy = "DV",
    imdv = 0, icens = 0,
    boolsave = TRUE,
    namsav = file.path(out_dir, "npde_FULL"),
    type.graph = "png",
    header = TRUE,
    detect = FALSE
  )
  npde_ok <- TRUE
  logf("NPDE 계산 성공")
}, silent = TRUE)

if (!npde_ok) {
  logf("NPDE 실패 → PD(예측차이 분포 백분위) 폴백 계산 시작")
  # PD 계산: 각 관찰 j에 대해 복제별 YSIM(j)와 비교한 경험적 누적분포값
  # 스택 구조(열)에서 j, j+nobs, j+2*nobs, ... 위치가 같은 관찰의 복제들
  pd <- numeric(nobs)
  ysim <- sim_df$YSIM
  yobs <- obs_used$DV
  for (j in seq_len(nobs)) {
    idx <- seq.int(from=j, to=j + nobs*(nsim-1), by=nobs)
    v <- ysim[idx]
    # 타이 보정: rank 방식 → ( #< + 0.5*#== ) / nsim
    lt <- sum(v < yobs[j], na.rm=TRUE)
    eq <- sum(v == yobs[j], na.rm=TRUE)
    pd[j] <- (lt + 0.5*eq) / nsim
  }
  # 안전 보정(0/1에 딱 붙으면 qnorm 폭주) → (n+1)분위 근사
  eps <- 0.5/nsim
  pd <- pmin(pmax(pd, eps), 1-eps)
  
  # 결과 저장
  pd_df <- cbind(as.data.frame(obs_used), PD=pd)
  fwrite(pd_df, file.path(out_dir, "pd_results.csv"))
  png(file.path(out_dir, "pd_hist.png"), width=1200, height=900, res=120)
  hist(pd, breaks=50, main="PD histogram", xlab="PD")
  dev.off()
  saveRDS(list(pd=pd, obs=obs_used), file=file.path(out_dir, "pd_result.rds"))
  logf("PD 계산 완료 및 저장 (npde가 수학적으로 불가능한 상황일 때 대안)")
} else {
  # NPDE 성공 시 요약/그림/CSV
  capture.output(summary(npde_obj), file = file.path(out_dir, "npde_summary.txt"))
  png(filename = file.path(out_dir, "npde_plots.png"), width=2000, height=1500, res=160)
  plot(npde_obj)
  dev.off()
  npde_res <- tryCatch({
    if (!is.null(npde_obj@results@res)) as.data.frame(npde_obj@results@res) else data.frame()
  }, error=function(e) {
    if (!is.null(npde_obj$results$res)) return(npde_obj$results$res)
    data.frame()
  })
  if (nrow(npde_res)>0) fwrite(npde_res, file.path(out_dir, "npde_results.csv"))
  saveRDS(npde_obj, file = file.path(out_dir, "npde_result.rds"))
  logf("NPDE 결과 저장 완료")
}

logf("✅ 파이프라인 종료 → %s", out_dir)
