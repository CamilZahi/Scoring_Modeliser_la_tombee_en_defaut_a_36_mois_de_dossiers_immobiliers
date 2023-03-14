# Installation des packages
install.packages("woe")
install.packages("woeBinnig")
install.packages("scorecard")
install.packages("dplyr")
install.packages("rjson")

library("rjson")

library(scorecard)
library(dplyr)

# Importation de la base de données
base_up  <- read.csv("C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/base_up.csv")
train_up <- read.csv("C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/train_up.csv")
test_up  <- read.csv("C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/test.csv")

# Affichage des premières lignes
head(base_up)

# Modification du type de variables
# Certaines variables ne sont pas au bon format.

base_up$defaut_36mois               <- as.character(base_up$defaut_36mois)
base_up$TYP_CNT_TRA_MAX_BRP         <- as.character(base_up$TYP_CNT_TRA_MAX_BRP)
base_up$ASU_BIEN_FIN_BRP            <- as.character(base_up$ASU_BIEN_FIN_BRP)
base_up$NAT_BIEN_FIN_BRP            <- as.character(base_up$NAT_BIEN_FIN_BRP)
base_up$COD_ETA_BIEN_CRI            <- as.character(base_up$COD_ETA_BIEN_CRI)
base_up$QUA_INT_MAX_BRP             <- as.character(base_up$QUA_INT_MAX_BRP)
base_up$TOP_PRET_RELAIS_BRP         <- as.character(base_up$TOP_PRET_RELAIS_BRP)
base_up$top_exist_conso_revo_BRP    <- as.character(base_up$top_exist_conso_revo_BRP)
base_up$TOP_NAT_FR_CRI              <- as.character(base_up$TOP_NAT_FR_CRI)
base_up$top_locatif                 <- as.character(base_up$top_locatif)

train_up$defaut_36mois               <- as.character(train_up$defaut_36mois)
train_up$TYP_CNT_TRA_MAX_BRP         <- as.character(train_up$TYP_CNT_TRA_MAX_BRP)
train_up$ASU_BIEN_FIN_BRP            <- as.character(train_up$ASU_BIEN_FIN_BRP)
train_up$NAT_BIEN_FIN_BRP            <- as.character(train_up$NAT_BIEN_FIN_BRP)
train_up$COD_ETA_BIEN_CRI            <- as.character(train_up$COD_ETA_BIEN_CRI)
train_up$QUA_INT_MAX_BRP             <- as.character(train_up$QUA_INT_MAX_BRP)
train_up$TOP_PRET_RELAIS_BRP         <- as.character(train_up$TOP_PRET_RELAIS_BRP)
train_up$top_exist_conso_revo_BRP    <- as.character(train_up$top_exist_conso_revo_BRP)
train_up$TOP_NAT_FR_CRI              <- as.character(train_up$TOP_NAT_FR_CRI)
train_up$top_locatif                 <- as.character(train_up$top_locatif)

test_up$defaut_36mois                <- as.character(test_up$defaut_36mois)
test_up$TYP_CNT_TRA_MAX_BRP          <- as.character(test_up$TYP_CNT_TRA_MAX_BRP)
test_up$ASU_BIEN_FIN_BRP             <- as.character(test_up$ASU_BIEN_FIN_BRP)
test_up$NAT_BIEN_FIN_BRP             <- as.character(test_up$NAT_BIEN_FIN_BRP)
test_up$COD_ETA_BIEN_CRI             <- as.character(test_up$COD_ETA_BIEN_CRI)
test_up$QUA_INT_MAX_BRP              <- as.character(test_up$QUA_INT_MAX_BRP)
test_up$TOP_PRET_RELAIS_BRP          <- as.character(test_up$TOP_PRET_RELAIS_BRP)
test_up$top_exist_conso_revo_BRP     <- as.character(test_up$top_exist_conso_revo_BRP)
test_up$TOP_NAT_FR_CRI               <- as.character(test_up$TOP_NAT_FR_CRI)
test_up$top_locatif                  <- as.character(test_up$top_locatif)

# Discrétisation avec WOE
bins= woebin(base_up, y='defaut_36mois', positive =0, method="tree", var_skip = 'date_debloc_avec_crd')


# Poids des variables pour chaque observation dans la base de données
train_up_woe <- woebin_ply(train_up, bins)
test_up_woe <- woebin_ply(test_up, bins)

# Affichage des graphiques
woebin_plot(bins)

# Enregistrement des nouvelles variables discrétisées
bins_df = data.table::rbindlist(bins)

# Affichage des IV des variables 
bins_var <- distinct(bins_df[ ,  c("variable", "total_iv")])

# Export en csv
write.csv(train_up_woe, "C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/train_up_woe.csv", row.names = FALSE)
write.csv(test_up_woe, "C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/test_up_woe.csv", row.names = FALSE)
write.csv(bins_df,"C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/discret_up_woe.csv", row.names = FALSE)

# Export en json des bins 
bins_json <- toJSON(bins)
write(bins_json, "C:/Users/ekeun/OneDrive - Université Paris 1 Panthéon-Sorbonne/Pybooks/Projets M2_MOSEF/Projet SCORING/data/classes.json") 

