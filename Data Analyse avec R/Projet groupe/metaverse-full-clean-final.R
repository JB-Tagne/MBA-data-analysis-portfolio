###############################################################################
# 1. INSTALLATION ET CHARGEMENT DES PACKAGES
###############################################################################

# install.packages("car")
# install.packages("cluster")
# install.packages("DescTools")
# install.packages("dplyr")
# install.packages("explor")
# install.packages("FactoMineR")
# install.packages("factoextra")
# install.packages("ggplot2")
# install.packages("multcomp")
# install.packages("nnet")
# install.packages("nortest")
# install.packages("performance")
# install.packages("questionr")
# install.packages("tidyr")
# install.packages("vcd")
# install.packages("plotly")
# install.packages("see")

library(car)          
library(cluster)       
library(DescTools)     
library(dplyr)
library(explor)
library(FactoMineR)
library(factoextra)
library(ggplot2) 
library(grid)
library(multcomp)
library(nnet)
library(nortest)
library(performance)
library(questionr)
library(tidyr)
library(vcd)
library(plotly)
library(see)

###############################################################################
# 2. IMPORTATION DES DONNÉES
###############################################################################

# Importation du fichier CSV
metaverse_data <- read.csv("metaverse_dataset(1).csv", 
                           header = TRUE, 
                           sep = ",", 
                           stringsAsFactors = FALSE)

###############################################################################
# 3. APERÇU ET PRÉTRAITEMENT DES DONNÉES
###############################################################################

# Aperçu global et structure
str(metaverse_data)
summary(metaverse_data)

# Gestion des valeurs manquantes ou aberrantes
colSums(is.na(metaverse_data))  # Comptage des NA 

###############################################################################
# 4. STATISTIQUES DESCRIPTIVES
###############################################################################

# ------------------ Variables quantitatives ------------------
summary(metaverse_data$amount)
sd(metaverse_data$amount, na.rm = TRUE)

summary(metaverse_data$risk_score)
sd(metaverse_data$risk_score, na.rm = TRUE)

summary(metaverse_data$session_duration)
sd(metaverse_data$session_duration, na.rm = TRUE)

summary(metaverse_data$login_frequency)
sd(metaverse_data$login_frequency, na.rm = TRUE)

# ------------------ Variables qualitatives ------------------
table(metaverse_data$transaction_type)
table(metaverse_data$anomaly)
table(metaverse_data$age_group)

# ------------------ Analyse des comptes pseudonymisés ------------------
unique_sending   <- length(unique(metaverse_data$sending_address))
unique_receiving <- length(unique(metaverse_data$receiving_address))
unique_sending
unique_receiving

# Combinaison des adresses
all_addresses <- c(metaverse_data$sending_address, metaverse_data$receiving_address)
unique_total_addresses <- length(unique(all_addresses))
unique_total_addresses

# ------------------ Regroupements par adresse ------------------

# Regroupement par sending_address
group_sending <- metaverse_data %>%
  group_by(sending_address) %>%
  summarise(nb_transactions = n()) %>%
  ungroup()
summary(group_sending$nb_transactions)
sd(group_sending$nb_transactions)

# Regroupement par receiving_address
group_receiving <- metaverse_data %>%
  group_by(receiving_address) %>%
  summarise(nb_transactions = n()) %>%
  ungroup()
summary(group_receiving$nb_transactions)
sd(group_receiving$nb_transactions)

# Regroupement par adresse combinée
all_addresses <- bind_rows(
  dplyr::transmute(metaverse_data, address = sending_address),
  dplyr::transmute(metaverse_data, address = receiving_address)
)
group_all_addresses <- all_addresses %>%
  group_by(address) %>%
  summarise(nb_occurrences = n()) %>%
  ungroup() 
summary(group_all_addresses$nb_occurrences)
sd(group_all_addresses$nb_occurrences)

summary(metaverse_data)

# ------------------ Analyse des jours de transaction ------------------
# Conversion du timestamp et extraction du jour de la semaine  
metaverse_data$timestamp <- as.POSIXct(metaverse_data$timestamp, format = "%Y-%m-%d %H:%M:%S")
metaverse_data$jour_semaine <- weekdays(metaverse_data$timestamp)
day_counts <- table(metaverse_data$jour_semaine)

###############################################################################
# 5. VISUALISATIONS DES STATISTIQUES DESCRIPTIVES
###############################################################################

##### Visualisations de base ####

# Barplot : Transactions par jour de la semaine  
barplot(day_counts,
        main = "Transactions par jour de la semaine",
        xlab = "Jour de la semaine",
        ylab = "Nombre de transactions",
        col = "skyblue")

# Scatterplot : amount vs. risk_score, coloré par anomaly
ggplot(metaverse_data, aes(x = amount, y = risk_score, color = anomaly)) +
  geom_point(alpha = 0.5) +
  ggtitle("Nuage de points - amount vs. risk_score") +
  xlab("Montant") +
  ylab("Risk Score") +
  theme_minimal()

# Histogramme de "amount"
ggplot(metaverse_data, aes(x = amount)) +
  geom_histogram(bins = 30) +
  ggtitle("Histogramme de la variable Amount") +
  xlab("Montant de la transaction") +
  ylab("Fréquence")

# Boxplot : risk_score selon anomaly
ggplot(metaverse_data, aes(x = anomaly, y = risk_score)) +
  geom_boxplot() +
  ggtitle("Boxplot du Risk Score selon l'Anomaly") +
  xlab("Niveau de risque (anomaly)") +
  ylab("Risk Score")

# Histogrammes et Boxplots supplémentaires
ggplot(metaverse_data, aes(x = hour_of_day)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Distribution of Hour of Day", x = "Hour of Day", y = "Frequency")

ggplot(metaverse_data, aes(x = amount)) +
  geom_histogram(binwidth = 50, fill = "green", color = "black") +
  labs(title = "Distribution of Transaction Amounts", x = "Amount", y = "Frequency")

ggplot(metaverse_data, aes(y = amount)) +
  geom_boxplot(fill = "green", color = "black") +
  labs(title = "Boxplot of Amoun", y = "Session Duration (minutes)")

ggplot(metaverse_data, aes(y = session_duration)) +
  geom_boxplot(fill = "orange", color = "black") +
  labs(title = "Boxplot of Session Duration", y = "Session Duration (minutes)")

ggplot(metaverse_data, aes(y = risk_score)) +
  geom_boxplot(fill = "purple", color = "black") +
  labs(title = "Boxplot of Risk Scores", y = "Risk Score")

ggplot(metaverse_data, aes(y = login_frequency)) +
  geom_boxplot(fill = "pink", color = "black") +
  labs(title = "Boxplot of Login Frequency", y = "Login Frequency")

ggplot(metaverse_data, aes(y = hour_of_day)) +
  geom_boxplot(fill = "yellow", color = "black") +
  labs(title = "Boxplot of Login Frequency", y = "Login Frequency")

# Graphiques en barres et diagrammes circulaires pour les variables qualitatives
ggplot(metaverse_data, aes(x = transaction_type)) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Distribution of Transaction Type", x = "Transaction Type", y = "Frequency")

ggplot(metaverse_data, aes(x = purchase_pattern)) +
  geom_bar(fill = "yellow", color = "black") +
  labs(title = "Distribution of Purchase Pattern", x = "Purchase Pattern", y = "Frequency")

ggplot(metaverse_data, aes(x = anomaly)) +
  geom_bar(fill = "darkblue", color = "black") +
  labs(title = "Distribution of Anomaly", x = "Anomaly", y = "Frequency")

ggplot(metaverse_data, aes(x = "", fill = age_group)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Distribution of Age Group") +
  theme_void()

ggplot(metaverse_data, aes(x = "", fill = location_region)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Distribution of Location Region") +
  theme_void()

metaverse_data$ip_prefix <- as.factor(metaverse_data$ip_prefix)
ggplot(metaverse_data, aes(x = "", fill = ip_prefix)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Distribution of IP Prefix") +
  theme_void()

# Graphiques de dispersion avec courbe de régression
ggplot(metaverse_data, aes(x = amount, y = risk_score)) +
  geom_point(color = "lightblue") +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Scatter Plot of Amount vs. Risk Score", x = "Amount", y = "Risk Score")
wilcox.test(metaverse_data$amount, metaverse_data$risk_score)

ggplot(metaverse_data, aes(x = session_duration, y = login_frequency)) +
  geom_point(color = "darkgreen") +
  geom_smooth(method = "lm", col = "green") +
  labs(title = "Scatter Plot of Session Duration vs. Login Frequency", x = "Session Duration (minutes)", y = "Login Frequency")
wilcox.test(metaverse_data$session_duration, metaverse_data$login_frequency)

ggplot(metaverse_data, aes(x = session_duration, y = amount)) +
  geom_point(color = "pink") +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Scatter Plot of Amount vs. Session Duration", x = "Session duration (minutes)", y = "Amount")

# ------------------ Variables qualitatives x qualitatives ------------------

# Table de contingence et graphiques associés pour 'Location region' et 'IP Prefix'
cross_tab <- table(metaverse_data$location_region, metaverse_data$ip_prefix )
print(cross_tab)
cprop(cross_tab)
lprop(cross_tab)

metaverse_data$ip_prefix <- as.factor(metaverse_data$ip_prefix)  # Conversion en facteur
ggplot(metaverse_data, aes(x = location_region, fill = ip_prefix)) +
  geom_bar(position = "stack") +
  labs(title = "Stacked Bar Plot of Location Region by IP Prefix", x = "Location Region", y = "Count", fill = "IP Prefix")
mosaic(~ location_region + ip_prefix, data = metaverse_data, shade = TRUE, legend = TRUE)

# Table de contingence et graphiques associés pour 'Transaction Type' et 'Purchase Pattern'
cross_tab <- table(metaverse_data$transaction_type, metaverse_data$purchase_pattern )
print(cross_tab)
cprop(cross_tab)
lprop(cross_tab)

ggplot(metaverse_data, aes(x = transaction_type, fill = purchase_pattern)) +
  geom_bar(position = "stack") +
  labs(title = "Stacked Bar Plot of Transaction Type by Purchase Pattern", x = "Transaction Type", y = "Count", fill = "Purchase Pattern")
mosaic(~ transaction_type + purchase_pattern, data = metaverse_data, shade = TRUE, legend = TRUE)

# ------------------ Variables quantitatives x qualitatives ------------------

# Boxplot : amount par age_group
set.seed(001)
n <- length(unique(metaverse_data$age_group))
colors <- sample(colors(), n)
ggplot(metaverse_data, aes(x = age_group, y = amount, fill = age_group)) +
  geom_boxplot() +
  scale_fill_manual(values = colors) +
  labs(title = "Boxplot of Amount by Age Group",
       x = "Age Group",
       y = "Amount") +
  theme_minimal()

# Boxplot : amount par transaction_type
set.seed(123)
n <- length(unique(metaverse_data$transaction_type))
colors <- sample(colors(), n)
ggplot(metaverse_data, aes(x = transaction_type, y = amount, fill = transaction_type)) +
  geom_boxplot() +
  scale_fill_manual(values = colors) +
  labs(title = "Boxplot of Amount by Transaction Type",
       x = "Transaction Type",
       y = "Amount") +
  theme_minimal()

# ------------------ Variables quantitatives x quantitatives ------------------

# Graphiques de dispersion redondants pour explorer les relations entre variables
ggplot(metaverse_data, aes(x = amount, y = risk_score)) +
  geom_point(color = "lightblue") +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Scatter Plot of Amount vs. Risk Score", x = "Amount", y = "Risk Score")
wilcox.test(metaverse_data$amount, metaverse_data$risk_score)

ggplot(metaverse_data, aes(x = session_duration, y = login_frequency)) +
  geom_point(color = "darkgreen") +
  geom_smooth(method = "lm", col = "green") +
  labs(title = "Scatter Plot of Session Duration vs. Login Frequency", x = "Session Duration (minutes)", y = "Login Frequency")
wilcox.test(metaverse_data$session_duration, metaverse_data$login_frequency)

ggplot(metaverse_data, aes(x = session_duration, y = amount)) +
  geom_point(color = "pink") +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Scatter Plot of Amount vs. Session Duration", x = "Session duration (minutes)", y = "Amount")

# ------------------ Corrélations entre variables quantitatives ------------------
cor_test_amt_sess <- cor.test(metaverse_data$amount, 
                              metaverse_data$session_duration, 
                              method = "pearson")
cat("\nCorrélation amount ~ session_duration\n")
print(cor_test_amt_sess)

cor_test_amt_risk <- cor.test(metaverse_data$amount, 
                              metaverse_data$risk_score, 
                              method = "pearson")
cat("\nCorrélation amount ~ risk_score\n")
print(cor_test_amt_risk)

cor_test_sess_risk <- cor.test(metaverse_data$session_duration, 
                               metaverse_data$risk_score, 
                               method = "pearson")
cat("\nCorrélation session_duration ~ risk_score\n")
print(cor_test_sess_risk)

# ------------------ Variables quantitatives x qualitatives x quantitatives ------------------

# Nuages de points segmentés par transaction_type et hour_of_day
ggplot(metaverse_data, aes(x = session_duration, y = amount, color = transaction_type)) +
  geom_point(size = 0.6) +
  labs(title = "Scatter Plot of Session Duration and Amount by Transaction Type",
       x = "Session Duration",
       y = "Amount") +
  theme_minimal()

metaverse_data$hour_of_day <- as.factor(metaverse_data$hour_of_day)
ggplot(metaverse_data, aes(x = session_duration, y = amount, color = transaction_type)) +
  geom_point(size = 0.5, alpha = 0.5) +
  facet_wrap(~ hour_of_day) +
  labs(title = "Scatter Plot of Session Duration and Amount by Transaction Type and Hour of Day",
       x = "Session Duration",
       y = "Amount") +
  theme_minimal()

ggplot(metaverse_data, aes(x = session_duration, y = amount, color = transaction_type)) +
  geom_point(size = 0.6) +
  facet_wrap(~ transaction_type) +
  labs(title = "Scatter Plot of Session Duration and Amount by Transaction Type",
       x = "Session Duration",
       y = "Amount") +
  theme_minimal()

ggplot(metaverse_data, aes(x = risk_score, y = login_frequency, color = anomaly)) +
  geom_point(size = 1) +
  labs(title = "Scatter Plot of Risk Score and Login Frequency by Anomaly",
       x = "Risk Score",
       y = "Login Frequency") +
  theme_minimal()

###############################################################################
# 6. ANALYSES FACTORIÈRES ET D'ANALYSE EN CORRESPONDANCE
###############################################################################

#### ANALYSE FACTORIELLE DE CORRESPONDANCES (AFC)
metaverse_data <- metaverse_data %>%
  mutate(purchase_pattern = as.factor(purchase_pattern),
         hour_of_day = as.factor(hour_of_day),
         risk_score_category = cut(risk_score, breaks = 5, labels = c("Risk - Very Low", "Risk - Low", "Risk - Medium", "Risk - High", "Risk - Very High")),
         amount_category = cut(amount, breaks = 5, labels = c("Amount - Very Low", "Amount - Low", "Amount - Medium", "Amount - High", "Amount - Very High")),
         session_duration_category = cut(session_duration, breaks = 5, labels = c("Session - Very Short", "Session - Short", "Session - Medium", "Session - Long", "Session - Very Long")))

# AFC entre amount_category et risk_score_category
contingency_table <- table(metaverse_data$amount_category, metaverse_data$risk_score_category)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre amount_category et purchase_pattern
contingency_table <- table(metaverse_data$amount_category, metaverse_data$purchase_pattern)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre purchase_pattern et risk_score_category
contingency_table <- table(metaverse_data$purchase_pattern, metaverse_data$risk_score_category)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre risk_score_category et session_duration_category
contingency_table <- table(metaverse_data$risk_score_category, metaverse_data$session_duration_category)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre risk_score_category et anomaly
contingency_table <- table(metaverse_data$risk_score_category, metaverse_data$anomaly)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre risk_score_category et hour_of_day
contingency_table <- table(metaverse_data$risk_score_category, metaverse_data$hour_of_day)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre amount_category et age_group
contingency_table <- table(metaverse_data$amount_category, metaverse_data$age_group)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

# AFC entre risk_score_category et location_region
contingency_table <- table(metaverse_data$risk_score_category, metaverse_data$location_region)
res.ca <- CA(contingency_table, graph = FALSE)
res.ca |> explor::explor()

#### ANALYSE EN CORRESPONDANCE MULTIPLE (ACM)
qualitative_alts <- metaverse_data[, c("hour_of_day", "ip_prefix", "transaction_type", "location_region", "purchase_pattern", "age_group", "anomaly")]
qualitative_alts <- na.omit(qualitative_alts)
qualitative_alts[] <- lapply(qualitative_alts, as.factor)
lapply(qualitative_alts, levels)
acm_result <- MCA(qualitative_alts, graph = TRUE)
acm_result |> explor::explor()

###############################################################################
# 7. SEGMENTATION DES DONNÉES
###############################################################################

#### Classification Ascendante Hiérarchique (CAH)
set.seed(123)
metaverse_data_sample <- metaverse_data %>%
  group_by(age_group, purchase_pattern, transaction_type, anomaly) %>%
  sample_frac(size = 0.3)
sample_size <- nrow(metaverse_data_sample)
print(sample_size)

metaverse_data_sample_quanti <- metaverse_data_sample[, !names(metaverse_data_sample) %in% c("hour_of_day", "ip_prefix", "timestamp", "sending_address", "receiving_address", "transaction_type", "location_region", "purchase_pattern", "age_group", "anomaly", "risk_score_category", "amount_category", "session_duration_category")]
distance_matrix <- dist(metaverse_data_sample_quanti, method = "euclidean")
hc <- hclust(distance_matrix, method = "ward.D2")
plot(hc, main = "Dendrogramme de la Classification Ascendante Hiérarchique", xlab = "", sub = "", cex = 0.9)
clusters_cah <- cutree(hc, k = 3)
metaverse_data_sample_quanti$cluster_cah <- clusters_cah
metaverse_data_sample$cluster_cah <- clusters_cah
plot(metaverse_data_sample_quanti[, c("amount", "login_frequency", "risk_score", "session_duration", "cluster_cah")], col = clusters_cah, pch = 16, cex = 1.2, main = "Regroupement par segmentation hiérarchique ascendante")

# Description des classes (statistiques descriptives par segment)
metaverse_data_sample_desc <- metaverse_data_sample %>%
  rename_with(~ gsub("_", "-", .x), c("amount", "login_frequency", "session_duration", "risk_score"))
metaverse_data_sample_desc <- metaverse_data_sample_desc %>%
  group_by(cluster_cah) %>%
  summarise(
    across(
      .cols = c("amount", "login-frequency", "session-duration", "risk-score"),
      .fns = list(
        mean = ~ mean(.x, na.rm = TRUE),
        median = ~ median(.x, na.rm = TRUE),
        sd = ~ sd(.x, na.rm = TRUE)
      )
    )
  )
metaverse_data_sample_desc_long <- metaverse_data_sample_desc %>%
  pivot_longer(cols = -cluster_cah, names_to = "Variable", values_to = "Value") %>%
  separate(Variable, into = c("Variable", "Statistic"), sep = "_") %>%
  pivot_wider(names_from = Statistic, values_from = Value)
metaverse_data_sample_desc_long <- metaverse_data_sample_desc_long %>%
  mutate(Variable_Segment = paste(Variable, cluster_cah, sep = "-")) %>%
  select(Variable_Segment, mean, median, sd)
metaverse_data_sample_desc_long <- metaverse_data_sample_desc_long %>%
  arrange(Variable_Segment)
print(metaverse_data_sample_desc_long, width = Inf, n=40)

metaverse_data_sample$amount_tenth <- metaverse_data_sample$amount / 10
metaverse_data_sample$login_frequency_ten <- metaverse_data_sample$login_frequency * 10
segment_medians <- metaverse_data_sample %>%
  group_by(cluster_cah) %>%
  summarise(across(c("amount_tenth", "risk_score", "login_frequency_ten", "session_duration"), median, na.rm = TRUE))
segment_medians_long <- segment_medians %>%
  pivot_longer(cols = -cluster_cah, names_to = "Variable", values_to = "Value")
ggplot(segment_medians_long, aes(x = Variable, y = Value, group = cluster_cah, color = as.factor(cluster_cah))) +
  geom_line(linewidth = 1.5) +
  labs(title = "Graphique en coordonnées parallèles par segment",
       x = "Variables",
       y = "Valeurs moyennes",
       color = "cluster_cah") +
  theme_minimal()

#### K-means clustering
seg_data <- metaverse_data %>%
  dplyr::select(amount, session_duration, risk_score, login_frequency) %>%
  na.omit()
seg_data_scaled <- scale(seg_data)
set.seed(123)
max_k <- 10
seg_data_scaled_df <- as.data.frame(seg_data_scaled)
wss_values <- numeric(max_k)
for(k in 1:max_k) {
  km_res <- kmeans(seg_data_scaled_df, centers = k, nstart = 25)
  wss_values[k] <- km_res$tot.withinss
}
plot(1:max_k, wss_values, 
     type = "b", pch = 19,
     xlab = "Nombre de clusters (k)",
     ylab = "Total within-cluster sum of squares (WSS)",
     main = "Courbe du coude (WSS) - Toutes les observations")
k <- 3
kmeans_res <- kmeans(seg_data_scaled_df, centers = k, nstart = 25)
metaverse_data$cluster_kmeans <- factor(kmeans_res$cluster, levels = c("1", "2", "3"))
desc_kmeans <- aggregate(seg_data, 
                         by = list(cluster = metaverse_data$cluster_kmeans), 
                         FUN = mean)
desc_kmeans
fviz_cluster(kmeans_res, 
             data = seg_data_scaled_df, 
             geom = "point",           
             ellipse.type = "convex",
             palette = c("#F8766D", "#619CFF", "#00BA38"),
             main = "Clusters k-means")
pca_res <- prcomp(seg_data_scaled_df, scale. = TRUE)
pca_data <- as.data.frame(pca_res$x[, 1:3])
pca_data$cluster <- metaverse_data$cluster_kmeans
plot_ly(pca_data, 
        x = ~PC1, y = ~PC2, z = ~PC3, 
        color = ~cluster, 
        colors = c("#F8766D", "#619CFF", "#00BA38"),
        type = "scatter3d", 
        mode = "markers") %>% 
  layout(title = "Clusters k-means en 3D (ACP)")

# Description des classes pour K-means
metaverse_data_desc <- metaverse_data %>%
  rename_with(~ gsub("_", "-", .x), c("amount", "login_frequency", "session_duration", "risk_score"))
metaverse_data_desc <- metaverse_data_desc %>%
  group_by(cluster_kmeans) %>%
  summarise(
    across(
      .cols = c("amount", "login-frequency", "session-duration", "risk-score"),
      .fns = list(
        mean = ~ mean(.x, na.rm = TRUE),
        median = ~ median(.x, na.rm = TRUE),
        sd = ~ sd(.x, na.rm = TRUE)
      )
    )
  )
metaverse_data_desc_long <- metaverse_data_desc %>%
  pivot_longer(cols = -cluster_kmeans, names_to = "Variable", values_to = "Value") %>%
  separate(Variable, into = c("Variable", "Statistic"), sep = "_") %>%
  pivot_wider(names_from = Statistic, values_from = Value)
metaverse_data_desc_long <- metaverse_data_desc_long %>%
  mutate(Variable_Segment = paste(Variable, cluster_kmeans, sep = "-")) %>%
  dplyr::select(Variable_Segment, mean, median, sd)
metaverse_data_desc_long <- metaverse_data_desc_long %>%
  arrange(Variable_Segment)
print(metaverse_data_desc_long, width = Inf, n=40)
metaverse_data$amount_cor <- metaverse_data$amount / 10
segment_medians <- metaverse_data %>%
  group_by(cluster_kmeans) %>%
  summarise(across(c("amount_cor", "risk_score", "login_frequency", "session_duration"), median, na.rm = TRUE))
segment_medians_long <- segment_medians %>%
  pivot_longer(cols = -cluster_kmeans, names_to = "Variable", values_to = "Value")
cluster_colors <- c("1" = "#F8766D", "2" = "#619CFF", "3" = "#00BA38")
ggplot(segment_medians_long, aes(x = Variable, y = Value, group = cluster_kmeans, color = as.factor(cluster_kmeans))) +
  geom_line(size = 1.5) +
  scale_color_manual(values = cluster_colors) +
  labs(title = "Graphique en coordonnées parallèles par segment",
       x = "Variables",
       y = "Valeurs moyennes",
       color = "cluster_kmeans") +
  theme_minimal()

###############################################################################
# 8. FORMULATION DES HYPOTHÈSES & TESTS STATISTIQUES
###############################################################################
 
# ------------------ Hypothèse 1 : Anomaly ------------------
metaverse_data$anomaly <- as.factor(metaverse_data$anomaly)
metaverse_data$cluster_kmeans <- as.factor(metaverse_data$cluster_kmeans)
tab_anomaly_cluster <- table(metaverse_data$anomaly, metaverse_data$cluster_kmeans)
chi2_test <- chisq.test(tab_anomaly_cluster)
print(chi2_test)
mosaicplot(tab_anomaly_cluster,
           main = "Répartition de 'anomaly' par 'cluster_kmeans'",
           xlab = "Clusters",
           ylab = "Anomaly",
           col = c("#F8766D", "#619CFF", "#00BA38"))

# ------------------ Hypothèse 2 : Hour of Day ------------------
metaverse_data$cluster_kmeans <- as.factor(metaverse_data$cluster_kmeans)
metaverse_data$hour_of_day <- as.numeric(metaverse_data$hour_of_day)
kruskal_test <- kruskal.test(hour_of_day ~ cluster_kmeans, data = metaverse_data)
print(kruskal_test)
pairwise.wilcox.test(
  x = metaverse_data$hour_of_day,
  g = metaverse_data$cluster_kmeans,
  p.adjust.method = "bonferroni"
)
ggplot(metaverse_data, aes(x = hour_of_day, fill = cluster_kmeans)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c("1" = "#F8766D", "2" = "#619CFF", "3" = "#00BA38")) +
  labs(title = "Densité de l'heure de transaction par cluster",
       x = "Hour of Day",
       y = "Densité") +
  theme_minimal()

# ------------------ Hypothèse 3 : Sending Address ------------------
tab_address_cluster <- table(metaverse_data$cluster_kmeans, metaverse_data$sending_address)
GTest(tab_address_cluster)

# ------------------ Hypothèse 4 : Transaction Type ------------------
metaverse_data$transaction_type <- as.factor(metaverse_data$transaction_type)
metaverse_data$cluster_kmeans   <- as.factor(metaverse_data$cluster_kmeans)
tab_purchase_cluster <- table(metaverse_data$transaction_type, metaverse_data$cluster_kmeans)
chi2_test <- chisq.test(tab_purchase_cluster)
print(chi2_test)
mosaicplot(tab_purchase_cluster,
           main = "Répartition de transaction_type par cluster_kmeans",
           xlab = "Clusters",
           ylab = "Transaction Type",
           col = c("#F8766D", "#619CFF", "#00BA38"))

# ------------------ Hypothèse 5 : Location Region ------------------
metaverse_data$location_region <- as.factor(metaverse_data$location_region)
metaverse_data$cluster_kmeans   <- as.factor(metaverse_data$cluster_kmeans)
tab_location_cluster <- table(metaverse_data$location_region, metaverse_data$cluster_kmeans)
chi2_test <- chisq.test(tab_location_cluster)
print(chi2_test)
mosaicplot(tab_location_cluster,
           main = "Répartition de location_region par cluster_kmeans",
           ylab = "Clusters",
           xlab = "Location Region",
           col = c("#F8766D", "#619CFF", "#00BA38"))

# ------------------ Hypothèse 6 : Montant ------------------
anova_model <- aov(amount ~ cluster_kmeans, data = metaverse_data)
summary(anova_model)
qqnorm(anova_model$residuals, main = "QQ-plot des résidus de l'ANOVA")
qqline(anova_model$residuals, col = "red")
length(anova_model$residuals)
shapiro.test(anova_model$residuals[0:5000])
ad.test(anova_model$residuals)
hist(anova_model$residuals, breaks = 30, main = "Histogramme des résidus de l'ANOVA", xlab = "Résidus")
levene_test <- leveneTest(amount ~ cluster_kmeans, data = metaverse_data)
print(levene_test)
qqnorm(anova_model$residuals, main = "QQ-plot des résidus de l'ANOVA")
qqline(anova_model$residuals, col = "red")
leveneTest(amount ~ cluster_kmeans, data = metaverse_data)
ggplot(metaverse_data, aes(x = factor(cluster_kmeans), y = amount, fill = factor(cluster_kmeans))) +
  geom_boxplot() +
  labs(title = "Boxplot de amount par cluster_kmeans", x = "Cluster K-means", y = "Amount") +
  scale_fill_manual(name = "Cluster K-means", values = cluster_colors) +
  theme_minimal()
kruskal_test <- kruskal.test(amount ~ cluster_kmeans, data = metaverse_data)
kruskal_test
pairwise.wilcox.test(
  x = metaverse_data$amount,
  g = metaverse_data$cluster_kmeans,
  p.adjust.method = "bonferroni"
)
ggplot(metaverse_data, aes(x = amount, fill = cluster_kmeans)) +
  geom_density(alpha = 0.4) +
  labs(title = "Densité du montant par cluster",
       x = "Montat",
       y = "Densité") +
  theme_minimal()
tukey_result <- glht(anova_model, linfct = mcp(cluster_kmeans = "Tukey"))
summary(tukey_result)

# ------------------ Hypothèse 7 : Risk Score avec interaction ------------------
anova_two_way <- aov(risk_score ~ cluster_kmeans * anomaly, data = metaverse_data)
summary(anova_two_way)
qqnorm(anova_two_way$residuals, main = "QQ-plot des résidus de l'ANOVA à deux facteurs")
qqline(anova_two_way$residuals, col = "red")
leveneTest(risk_score ~ cluster_kmeans * anomaly, data = metaverse_data)
metaverse_data$risk_score_trans <- 1/(metaverse_data$risk_score)
boxcox_result <- boxcox(anova_two_way)
lambda <- boxcox_result$x[which.max(boxcox_result$y)]
metaverse_data$risk_score_trans <- (metaverse_data$risk_score^lambda - 1) / lambda
anova_two_way_trans <- aov(risk_score_trans ~ cluster_kmeans * transaction_type, data = metaverse_data)
summary(anova_two_way_trans)
qqnorm(anova_two_way_trans$residuals, main = "QQ-plot des résidus de l'ANOVA à deux facteurs (log)")
qqline(anova_two_way_trans$residuals, col = "red")
anova_robust <- lmrob(risk_score ~ cluster_kmeans * transaction_type, data = metaverse_data)
summary(anova_robust)

# ------------------ Hypothèse 8 : Répartition du Risk Score ------------------
metaverse_data$cluster_kmeans <- as.factor(metaverse_data$cluster_kmeans)
kruskal_test <- kruskal.test(risk_score ~ cluster_kmeans, data = metaverse_data)
kruskal_test
pairwise.wilcox.test(
  x = metaverse_data$risk_score,
  g = metaverse_data$cluster_kmeans,
  p.adjust.method = "bonferroni"
)
ggplot(metaverse_data, aes(x = risk_score, fill = cluster_kmeans)) +
  geom_density(alpha = 0.4) +
  labs(title = "Densité du score de risque par cluster",
       x = "Score de risque",
       y = "Densité") +
  scale_fill_manual(name = "Cluster K-means", values = cluster_colors) +
  theme_minimal()

# ------------------ Hypothèse 9 : Influence du montant sur le Risk Score ------------------
metaverse_data_ancova <- metaverse_data %>%
  filter(!is.na(amount), !is.na(risk_score))
ancova_model <- aov(risk_score ~ cluster_kmeans + amount, data = metaverse_data_ancova)
summary(ancova_model)
residuals <- residuals(ancova_model)
fitted_values <- fitted(ancova_model)
diagnostic_data <- data.frame(
  fitted_values = fitted_values,
  residuals = residuals
)
ggplot(diagnostic_data, aes(x = residuals)) +
  geom_histogram(binwidth = 0.5, fill = "orange", color = "darkgrey") +
  labs(title = "Histogramme des résidus",
       x = "Résidus",
       y = "Fréquence") +
  theme_minimal()
ggplot(metaverse_data, aes(x = amount, y = risk_score)) +
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Linéarité entre amount et risk_score",
       x = "Amount",
       y = "Risk Score") +
  theme_minimal()
ggplot(data.frame(residuals), aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line() +
  labs(title = "QQ-plot des résidus",
       x = "Quantiles théoriques",
       y = "Quantiles des résidus") +
  theme_minimal()
ggplot(data.frame(fitted_values = fitted(ancova_model), residuals = residuals), aes(x = fitted_values, y = residuals)) +
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Homogénéité des variances",
       x = "Valeurs ajustées",
       y = "Résidus") +
  theme_minimal()
ggplot(diagnostic_data, aes(x = residuals)) +
  geom_histogram(binwidth = 0.5, fill = "orange", color = "darkgrey") +
  labs(title = "Histogramme des résidus",
       x = "Résidus",
       y = "Fréquence") +
  theme_minimal()

# ------------------ Hypothèse 10 : Login Frequency ------------------
metaverse_data$cluster_kmeans <- as.factor(metaverse_data$cluster_kmeans)
kruskal_test <- kruskal.test(login_frequency ~ cluster_kmeans, data = metaverse_data)
kruskal_test
pairwise.wilcox.test(
  x = metaverse_data$login_frequency,
  g = metaverse_data$cluster_kmeans,
  p.adjust.method = "bonferroni"
)
ggplot(metaverse_data, aes(x = login_frequency, fill = cluster_kmeans)) +
  geom_density(alpha = 0.4) +
  labs(title = "Densité de fréquence de connexion par cluster",
       x = "Fréquence de Connexion",
       y = "Densité") +
  scale_fill_manual(name = "Cluster K-means", values = cluster_colors) +
  theme_minimal()

###############################################################################
# 9. MODÉLISATION
###############################################################################

##### Régression logistique multinomiale
metaverse_data$cluster_kmeans   <- as.factor(metaverse_data$cluster_kmeans)
metaverse_data$transaction_type <- as.factor(metaverse_data$transaction_type)
model <- multinom(cluster_kmeans ~ transaction_type, data = metaverse_data)
summary(model)
model_null <- multinom(cluster_kmeans ~ 1, data = metaverse_data)
anova(model_null, model, test = "Chisq")

##### Régression linéaire simple : prédire session_duration
modele_lm <- lm(session_duration ~ login_frequency, data = metaverse_data)
summary(modele_lm)
ggplot(metaverse_data, aes(x = login_frequency, y = session_duration)) +
  geom_point(color = "pink", alpha = 0.2) +
  geom_smooth(method = "lm", color = "purple", se = TRUE) +
  labs(title = "Régression linéaire entre Login Frequency et Session Duration",
       x = "Login Frequency",
       y = "Session Duration") +
  theme_minimal()

# Régressions linéaires par cluster
lmdata_cluster1 <- metaverse_data %>%
  filter(cluster_kmeans == "1")
modele_lm_c1 <- lm(session_duration ~ login_frequency, data = lmdata_cluster1)
summary(modele_lm_c1)
ggplot(lmdata_cluster1, aes(x = login_frequency, y = session_duration)) +
  geom_point(color = "#F8766D", alpha = 0.2) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Régression linéaire entre Login Frequency et Session Duration - Cluster 1",
       x = "Login Frequency",
       y = "Session Duration") +
  theme_minimal()

lmdata_cluster2 <- metaverse_data %>%
  filter(cluster_kmeans == "2")
modele_lm_c2 <- lm(session_duration ~ login_frequency, data = lmdata_cluster2)
summary(modele_lm_c2)
ggplot(lmdata_cluster2, aes(x = login_frequency, y = session_duration)) +
  geom_point(color = "#619CFF", alpha = 0.2) +
  geom_smooth(method = "lm", color = "navyblue", se = TRUE) +
  labs(title = "Régression linéaire entre Login Frequency et Session Duration - Cluster 2",
       x = "Login Frequency",
       y = "Session Duration") +
  theme_minimal()

lmdata_cluster3 <- metaverse_data %>%
  filter(cluster_kmeans == "3")
modele_lm_c3 <- lm(session_duration ~ login_frequency, data = lmdata_cluster3)
summary(modele_lm_c3)
ggplot(lmdata_cluster3, aes(x = login_frequency, y = session_duration)) +
  geom_point(color = "#00BA38", alpha = 0.2) +
  geom_smooth(method = "lm", color = "darkgreen", se = TRUE) +
  labs(title = "Régression linéaire entre Login Frequency et Session Duration - Cluster 3",
       x = "Login Frequency",
       y = "Session Duration") +
  theme_minimal()

##### Régression linéaire multiple : prédire risk_score  
metaverse_data$purchase_pattern <- as.factor(metaverse_data$purchase_pattern)
metaverse_data$transaction_type <- as.factor(metaverse_data$transaction_type)
metaverse_data$hour_of_day <- as.numeric(metaverse_data$hour_of_day)
model_amount <- lm(
  risk_score ~ purchase_pattern + transaction_type + hour_of_day + amount,
  data = metaverse_data
)
summary(model_amount)
check_model(model_amount) 
avPlots(model_amount)
