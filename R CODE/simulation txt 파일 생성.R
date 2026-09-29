# 템플릿 경로 설정
template_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/1000.txt"

# 폴더 생성 (없는 경우)
dir.create("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM", recursive = TRUE, showWarnings = FALSE)

# 템플릿 파일 확인
if (!file.exists(template_path)) {
  stop("❌ 템플릿 파일 경로가 잘못되었습니다: ", template_path)
}

# 템플릿 읽기
template_text <- readLines(template_path)

# 1000~1863번까지 복사하며 수정
for (i in 1000:1863) {
  modified_text <- gsub("1000", as.character(i), template_text)
  new_path <- sprintf("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/TEST/SIM/%d.txt", i)
  writeLines(modified_text, new_path)
}

cat("✅ 모든 파일 생성 완료 (1000~1863.txt)\n")
