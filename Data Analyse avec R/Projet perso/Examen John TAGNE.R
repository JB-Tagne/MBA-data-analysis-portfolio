# Charger les bibliothèques nécessaires
library(ggplot2)

# Charger les données depuis un fichier Excel
library(readxl)
exam <- read_excel("Examen.xlsx", sheet = "Données")

# Remplacer les valeurs manquantes par NA
exam[exam == ""] <- NA

# Afficher la structure du tableau
str(exam)

# Afficher la classe de chaque variable
sapply(exam, class)

# Afficher le tableau complet
print(exam)

# Afficher un résumé de la table
summary(exam)

# Quali univariée

# Tris à plat de Genre
table(exam$Genre, useNA = "ifany")

# Mode de Genre (valeur la plus fréquente)
mode_genre <- names(which.max(table(exam$Genre, useNA = "no")))
mode_genre

# Diagramme en bâtons de Genre avec couleur verte
barplot(table(exam$Genre, useNA = "ifany"), col = "green", main = "Répartition du Genre")

# Tris croisés de Genre selon Contrat
table(exam$Genre, exam$Contrat, useNA = "ifany")

# Quanti univariée

# Résumé de Salaire
summary(exam$Salaire)

# Nombre d'observations de Salaire
sum(!is.na(exam$Salaire))

# Calculs des statistiques de Salaire
min(exam$Salaire, na.rm = TRUE)
max(exam$Salaire, na.rm = TRUE)
quantile(exam$Salaire, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
mean(exam$Salaire, na.rm = TRUE)
sd(exam$Salaire, na.rm = TRUE)

# Box plot de Salaire
boxplot(exam$Salaire, main = "Boxplot du Salaire", col = "lightgray", ylab = "Salaire", na.rm = TRUE)
points(mean(exam$Salaire, na.rm = TRUE), col = "red", pch = 19)
abline(h = median(exam$Salaire, na.rm = TRUE), col = "blue", lwd = 2)

# Bivarié quali - quanti

# Box plot vert de Salaire par Genre
boxplot(Salaire ~ Genre, data = exam, col = "green", main = "Salaire par Genre", na.rm = TRUE)
points(aggregate(Salaire ~ Genre, data = exam, mean, na.rm = TRUE)$Salaire, col = "red", pch = 19)
abline(h = median(exam$Salaire, na.rm = TRUE), col = "blue", lwd = 2)

# Nuage de points entre Salaire et Age avec régression
plot(exam$Age, exam$Salaire, main = "Salaire en fonction de l'Âge", xlab = "Âge", ylab = "Salaire", col = "blue")
abline(lm(Salaire ~ Age, data = exam, na.action = na.omit), col = "red")

# Nuage de points de Salaire et Age selon Genre
plot(exam$Age, exam$Salaire, col = ifelse(exam$Genre == "HOMME", "green", "blue"), pch = 19, xlab = "Âge", ylab = "Salaire", main = "Salaire en fonction de l'Âge selon le Genre")
legend("topright", legend = c("Homme", "Femme"), col = c("green", "blue"), pch = 19)

# Test du khi2 entre Genre et Contrat
chisq.test(table(exam$Genre, exam$Contrat, useNA = "no"))

# Test de corrélation de Pearson entre Salaire et Age
cor.test(exam$Salaire, exam$Age, method = "pearson", use = "complete.obs")

# Matrice de corrélation entre Salaire et Age affichée sous forme de tableau graphique
cor_matrix <- cor(exam[, c("Salaire", "Age")], use = "complete.obs")
image(1:2, 1:2, cor_matrix, col = heat.colors(12), axes = FALSE, main = "Matrice de corrélation Salaire - Age")
axis(1, at = 1:2, labels = colnames(cor_matrix))
axis(2, at = 1:2, labels = colnames(cor_matrix), las = 2)
text(expand.grid(1:2, 1:2), labels = round(cor_matrix, 2), col = "black")

