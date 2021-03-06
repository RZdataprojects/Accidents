library(tidyverse)
library(ggplot2)
library(scales)
library(lubridate)
library(readr)
locale("he")

Sys.setlocale("LC_ALL", "Hebrew")
knitr::opts_chunk$set(echo = TRUE)
infodata <- read_csv(file = "C:/Users/Roei/Desktop/RR/accidents_fixed.csv", locale = locale(date_names = "he", encoding = "UTF-8"))



ABC<-aggregate(c(infodata["��' ������"],infodata["��� ������ �����"]), by=list(infodata$����), FUN=sum)
ABC["������ �� �����"]<-round(ABC$��..������/ABC$���.������.�����, 2)
colnames(ABC) <- c("����", "�� ������", "��� ������ �����","������ �� �����")
clabel=paste0(unlist(ABC["������ �� �����"]) , sep="")
ggplot(ABC, aes(y = unlist(ABC$`������ �� �����`), x=unlist(ABC$����))) +
  theme_bw(base_rect_size = 0) +
  geom_bar(position = 'dodge', stat="identity", width=0.8, fill="darkgray") +
  labs(y = "���� ������",
       x = "����")+
  geom_text(aes(label=clabel), position=position_dodge(width=0.1), vjust=-0.25)+
  labs(title = "���� ������ �� ���� �� �� ����" , x = "" , y = "���� ������ �� ����") +
  theme(axis.text.x = element_text(size=11, angle=0, vjust=1), plot.title = element_text(hjust = 0.5))+
  ylim(0,60)



###    ���� ������ �� ������� ������ ���� ��� (������ ��� ������� ���� �� ������) ��.�. ���� 
BIOKOT <- aggregate(c(infodata["��� ������"], infodata["������"]+infodata$`������ ���`), by=list(infodata$����), FUN=sum)
#Summing seekers by district.
colnames(BIOKOT) <- c("����", "�� ������", "BIK")

BIOKOT <- mutate(BIOKOT, BIOKOT["BIK"] <- (100*BIOKOT["BIK"] / sum(BIOKOT["�� ������"]))) #Percentage col. of TOTAL job seekers.
#Sorting by percentage
BIOKOT <- BIOKOT[order(BIOKOT["BIK"], decreasing = TRUE),]
BIOKOT$���� <- factor(BIOKOT$����, levels = BIOKOT$����)
tlabel=paste0(round(BIOKOT$BIK,3),"%")
ggplot(BIOKOT, aes(y = unlist(BIOKOT["BIK"]), x = unlist(BIOKOT["����"]))) +
  geom_bar(position = 'dodge', stat="identity", width=0.8, fill="navy") +
  geom_text(aes(label=tlabel),
            position=position_dodge(width=0.1), vjust=-0.25) +
  
  labs(title = "���� ������� ������ ���� ��� �� �� ����" , x = "" , y = "������ ��� ������� %") +
  theme(axis.text.x = element_text(size=11, angle=0, vjust=1), plot.title = element_text(hjust = 0.5))+
ylim(0,0.75)
###



infodata$����<-as.factor(infodata$����)
infodata["����"]<-as.factor(infodata$����)

