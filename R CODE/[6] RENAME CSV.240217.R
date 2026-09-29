
setwd("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER3/DATA")
getwd ()

# 데이터 불러오기
data <- read.csv("DATA.csv")

# 'ID' 값을 1부터 시작하여 N개의 행에 같은 숫자가 들어가도록 변경
for (i in 1:nrow(data)) {
  data$ID[i] <- ceiling(i / 289)
}

# 변경된 데이터를 확인
print(data)

# 변경된 데이터프레임을 새로운 이름으로 저장
write.csv(data, file = "DATA_VER1.csv", row.names = FALSE)












# 저장된 파일 경로 출력
print("데이터가 성공적으로 저장되었습니다.")







### 이어서 ID 붙이기 
#setwd("/Volumes/JIWo_o/MBMA/Ref2/ID 567 생성/RENAME CSV")
#getwd ()
# 데이터 불러오기
#data <- read.csv("SUM2_ref2_ver2.csv")

#start_number <- 731  # 시작할 숫자

# 'ID' 값을 start_number부터 시작하여 61개의 행에 같은 숫자가 들어가도록 변경
#for (i in 1:nrow(data)) {
#data$ID[i] <- start_number + ceiling(i / 61) - 1}

# 변경된 데이터를 확인
#print(data)

# 변경된 데이터프레임을 새로운 이름으로 저장
#write.csv(data, file = "SUM2_ref2_ver3.csv", row.names = FALSE)

# 저장된 파일 경로 출력
#print("데이터가 성공적으로 저장되었습니다.")
