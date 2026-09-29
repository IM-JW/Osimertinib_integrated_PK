library(dplyr)

input_path  <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/TEST/RESULT/STEP3/M"
output_path <- "C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.6/SIM/TEST/MIN"

if (!dir.exists(output_path)) dir.create(output_path, recursive = TRUE)

file_list <- list.files(path = input_path, pattern = "\\.csv$", full.names = TRUE)

all_data  <- data.frame()
set_value <- 1000

for (file in file_list) {
  dat <- read.csv(file, check.names = FALSE)
  names(dat) <- tolower(names(dat))
  if (!all(c("time", "pred") %in% names(dat))) stop(paste("필수 칼럼 누락:", file))
  
  filtered <- dat %>% filter(time >= 384, !is.na(pred))
  if (nrow(filtered) == 0) next
  
  top_row <- filtered %>% slice_min(order_by = pred, n = 1, with_ties = FALSE)
  
  top_row$SET <- set_value
  set_value <- set_value + 1
  
  all_data <- bind_rows(all_data, top_row)
}

write.csv(all_data, file = file.path(output_path, "CMIN_M.csv"), row.names = FALSE)
cat("저장 완료:", file.path(output_path, "CMIN_M.csv"), "\n")
