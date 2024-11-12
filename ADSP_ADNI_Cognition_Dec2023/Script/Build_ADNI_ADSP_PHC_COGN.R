#LONI - Freeze 2
#Alaina Durant - 10 2023

#directory
directory <- "C:/Users/durantam/VUMC/Research - Hohman - CNT/"
my_directory <- paste0(directory, "Team/Alaina_Durant/")
cog_directory <- paste0(directory, "Projects/ADSP-PHC/Freeze 2/Harmonization/Cognition/")

#library and functions
source(paste0(my_directory, "Scripts/load_libraries.R"))
source(paste0(my_directory, "Scripts/load_functions.R"))
  #function count(df$ID) works as length(unique(df$ID))


####################
##### ADSP IDs #####
####################

ADSP <- readRDS(paste0(directory, "Data/ADSP/2023/GCAD_Pre-r5_2023_IDLink.rds")) %>% 
  dplyr::filter(cohort == "ADNI") #obs/inds:1566


###############################
##### ADNI Cognitive Data #####
###############################

ADNI <- read.csv(paste0(cog_directory, "ADNI/Cleaned/ADNI_PHC_Cognition_CleanedNov2023.csv")) #obs:12533, cols:129, inds:3539


#############
### Merge ###
#############

#keep everyone with or without SUBJID
ADNI_ADSP <- merge(ADNI, ADSP, by.x = "PTID", by.y = "original_ID", all.x = T) #obs:12533, cols:131, inds:3539

#clean up
rm(ADNI, ADSP)


#############################
### Keep, Rename, Reorder ###
#############################

#Keep relevant variables
ADNI_ADSP <- ADNI_ADSP %>% dplyr::select(RID, SUBJID, Phase, VISCODE, VISCODE2, EXAMDATE, PHC_Visit, Sex, Education, Ethnicity,
                                         Race, Age, Diagnosis, PHC_MEM, PHC_MEM_SE, PHC_MEM_PreciseFilter, PHC_EXF, PHC_EXF_SE,
                                         PHC_EXF_PreciseFilter, PHC_LAN, PHC_LAN_SE, PHC_LAN_PreciseFilter, PHC_VSP, PHC_VSP_SE,
                                         PHC_VSP_PreciseFilter) #obs:12533, cols:25, inds:3539

#Rename variables
ADNI_ADSP <- ADNI_ADSP %>% dplyr::rename(PHASE=Phase, PHC_Sex=Sex, PHC_Education=Education, PHC_Ethnicity=Ethnicity, 
                                         PHC_Race=Race, PHC_Age_Cognition=Age, PHC_Diagnosis=Diagnosis)

#order variables
ADNI_ADSP <- ADNI_ADSP[order(ADNI_ADSP$RID, ADNI_ADSP$PHC_Visit),]


#######################
##### Save as csv #####
#######################

write.csv(ADNI_ADSP, paste0(directory, "Projects/ADSP-PHC/Freeze 2/LONI_Release_Oct2023/Cognition/ADSP_PHC_COGN_Nov2023.csv"), row.names = F)
