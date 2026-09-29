# 데이터 불러오기
data <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/VALI/VALI.csv")

# 빈도수 계산
sex_count <- table(data$SEX)

# 비율(%) 계산
sex_percent <- prop.table(sex_count) * 100

# 결과 출력
result <- data.frame(
  SEX = names(sex_count),
  Count = as.vector(sex_count),
  Percent = round(as.vector(sex_percent), 1)  # 소수점 1자리 반올림
)

print(result)

# 데이터 불러오기
data1 <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/TEST/TEST.csv")

# 빈도수 계산
sex_count1 <- table(data1$SEX)

# 비율(%) 계산
sex_percent1 <- prop.table(sex_count1) * 100

# 결과 출력
result <- data.frame(
  SEX2 = names(sex_count1),
  Count2 = as.vector(sex_count1),
  Percent2 = round(as.vector(sex_percent1), 1)  # 소수점 1자리 반올림
)

print(result)
