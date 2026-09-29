install.packages(
  "rsthemes",
  repos = c(gadenbuie = 'https://gadenbuie.r-universe.dev', getOption("repos"))
)
rsthemes::install_rsthemes()

# list installed themes
rsthemes::list_rsthemes()

# Try all themes
rsthemes::try_rsthemes()

# Try just the light, dark, or base16 themes, e.g.
rsthemes::try_rsthemes("light")

# Use a theme
rstudioapi::applyTheme("One Dark {rsthemes}")

# Set current theme to default light or dark theme
rsthemes::set_theme_light()
rsthemes::set_theme_dark()

# Set a specific theme to default light or dark theme
rsthemes::set_theme_light("One Light {rsthemes}")
rsthemes::set_theme_dark("One Dark {rsthemes}")

# Add current theme to your list of favorites
rsthemes::set_theme_favorite()

# Add a list of themes to your favorites
rsthemes::set_theme_favorite(
  c("GitHub {rsthemes}", "One Light {rsthemes}", "One Dark {rsthemes}")
)

# ~/.Rprofile
if (interactive()) {
  rsthemes::set_theme_light("GitHub {rsthemes}")
  rsthemes::set_theme_dark("Fairyfloss {rsthemes}")
  rsthemes::set_theme_favorite(
    c("GitHub {rsthemes}", 
      "One Light {rsthemes}", 
      "One Dark {rsthemes}")
  )
}
'if (interactive() && requireNamespace("rsthemes", quietly = TRUE)) {
  # Set preferred themes if not handled elsewhere..
  rsthemes::set_theme_light("One Light {rsthemes}")  # light theme
  rsthemes::set_theme_dark("One Dark {rsthemes}") # dark theme

  # Whenever the R session restarts inside RStudio...
  setHook("rstudio.sessionInit", function(isNewSession) {
    # Automatically choose the correct theme based on time of day
    rsthemes::use_theme_auto(dark_start = "18:00", dark_end = "6:00")
  }, action = "append")
}'

devtools::install_github("gadenbuie/rsthemes")
rsthemes::install_rsthemes()
rsthemes::install_rsthemes(include_base16 = TRUE)
rsthemes::list_rsthemes()rsthemes::list_rsthemes()

rstudioapi::addTheme("http://url-to-the-rstheme/", apply = TRUE)
rstudioapi::addTheme("https://raw.githubusercontent.com/batpigandme/night-owlish/master/rstheme/night-owlish.rstheme", apply = TRUE)

install.packages(
  "rsthemes",
  repos = c(gadenbuie = 'https://gadenbuie.r-universe.dev', getOption("repos"))
)
Or you can install rsthemes from GitHub with:
  
  # install.packages("devtools")
  devtools::install_github("gadenbuie/rsthemes")

  
  rsthemes::install_rsthemes()

rsthemes::install_rsthemes(include_base16 = TRUE)

# list installed themes
rsthemes::list_rsthemes()

# Try all themes
rsthemes::try_rsthemes()

# Try just the light, dark, or base16 themes, e.g.
rsthemes::try_rsthemes("light")
Use rstudioapi::applyTheme() to activate a theme from the R console, or use Tools > Global Options > Appearance to interactively select a theme.

# Use a theme
rstudioapi::applyTheme("One Dark {rsthemes}")

# Set current theme to default light or dark theme
rsthemes::set_theme_light()
rsthemes::set_theme_dark()

# Set a specific theme to default light or dark theme
rsthemes::set_theme_light("One Light {rsthemes}")
rsthemes::set_theme_dark("One Dark {rsthemes}")
To create a list of your favorite themes, you can use set_theme_favorite().

# Add current theme to your list of favorites
rsthemes::set_theme_favorite()

# Add a list of themes to your favorites
rsthemes::set_theme_favorite(
  c("GitHub {rsthemes}", "One Light {rsthemes}", "One Dark {rsthemes}")
)

# ~/.Rprofile
if (interactive()) {
  rsthemes::set_theme_light("GitHub {rsthemes}")
  rsthemes::set_theme_dark("Fairyfloss {rsthemes}")
  rsthemes::set_theme_favorite(
    c("GitHub {rsthemes}", 
      "One Light {rsthemes}", 
      "One Dark {rsthemes}")
  )
}

# ~/.Rprofile
options(
  rsthemes.theme_light = "Nord Snow Storm {rsthemes}",
  rsthemes.theme_dark = "Nord Polar Night Aurora {rsthemes}",
  rsthemes.theme_favorite = paste("One", c("Light", "Dark"), "{rsthemes}")
)

rstudioapi::addTheme("https://raw.githubusercontent.com/patrickshox/Mojave-Dark-RStudio-Theme/master/Mojave%20Dark.rstheme", apply=TRUE, force=TRUE)
rstudioapi::addTheme("https://raw.githubusercontent.com/patrickshox/Mojave-Dark-RStudio-Theme/master/Mojave%20Dark%20(Static).rstheme", apply=TRUE, force=TRUE)

install.packages("rstudioapi")

### add theme and apply immediately
rstudioapi::addTheme(
  tfse::github_raw("theme/driven-snow.rstheme", repo = "mkearney/driven-snow"),
  apply = TRUE
)

rstudioapi::addTheme("http://your/theme/path/theme.rstheme", apply = TRUE)

