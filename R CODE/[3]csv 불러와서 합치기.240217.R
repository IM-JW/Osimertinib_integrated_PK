


setwd("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER3/DATA")
getwd ()

# 현재 작업 중인 디렉토리에서 ".csv"로 끝나는 파일들의 이름을 가져옵니다.
file_names <- dir(pattern = "\\.csv$")

# ".csv"로 끝나는 파일들을 데이터프레임으로 읽어옵니다.
dfs <- lapply(file_names, read.csv)

# 읽어온 데이터프레임들을 하나의 데이터프레임으로 합쳐줍니다.
combined_df <- do.call(rbind, dfs)

# 합쳐진 데이터프레임을 새로운 csv 파일로 저장합니다.
write.csv(combined_df, "DATA.csv", row.names = FALSE)

#library(dplyr)

#setwd("/Volumes/JIWo_o/대학원/CPP")
#getwd ()

# CSV 파일 경로 지정
#combined_df <- "Ref3.csv"

# CSV 파일 불러오기
#data <- read.csv(SUM_ref2.csv)

# "CM" 및 "CP" 열에서 음수 값을 가진 행 찾기
#negative_rows <- data %>% filter(CM < 0 | CP < 0)

# 음수 값을 가진 행의 ID 값 추출
#ids_to_remove <- negative_rows$ID

# 해당 ID를 가진 모든 행 삭제
#data <- data %>% filter(!(ID %in% ids_to_remove))

# 결과를 다시 CSV 파일로 저장
#write.csv(data, "SUM2_ref2_ver1.csv", row.names = FALSE)

# 결과 출력
#print("작업이 완료되었습니다.")


#id새로지정 
#df <- read.csv("/Volumes/JIWo_o/대학원/CPP/CPP_Ref2_ver2/CSV/Ref2.csv")

#df <- df %>% mutate(ID = rep(1:1000, each = 57)) 

# 결과 확인
#setwd ("C:/Users/clinical/Desktop/prasugrel MBMA/NEW MBMA/CPP/2008_new/")
#getwd ()

#head(df)
#write.csv(df, file = "2008_v2.csv", row.names = FALSE)



