library(dplyr)
library(tidyr)

# 데이터 불러오기
demo <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER5.3/METABOLITE/VALIDATION/VALIDATION_demo.csv")

# 변수 성격 설정
categorical_vars <- c("SEX")
continuous_vars <- c("AGE", "WT", "ALB", "AST", "ALT", "SCE")

# SEX 변수 라벨링
demo$SEX <- factor(demo$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# 범주형 변수 요약: n (%)
cat_summary <- demo %>%
  select(all_of(categorical_vars)) %>%
  summarise(across(everything(),
                   ~ paste0(names(table(.)), ": ", as.vector(table(.)), " (", round(100 * prop.table(table(.)), 1), "%)"),
                   .names = "summary_{col}")) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Summary") %>%
  separate_rows(Summary, sep = ", ")

# 연속형 변수 요약: mean (SD)
cont_summary <- demo %>%
  select(all_of(continuous_vars)) %>%
  summarise(across(everything(), list(mean = ~ mean(., na.rm = TRUE),
                                      sd = ~ sd(., na.rm = TRUE)))) %>%
  pivot_longer(everything(),
               names_to = c("Variable", ".value"),
               names_sep = "_") %>%
  mutate(Summary = paste0(round(mean, 2), " (", round(sd, 2), ")")) %>%
  select(Variable, Summary)

# 결과 병합 및 출력
summary_table <- bind_rows(cat_summary, cont_summary)
print(summary_table)
