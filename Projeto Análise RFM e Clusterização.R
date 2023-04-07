#setwd("C:/Users/")
#getwd()

library(tidyverse)
library(dplyr)
library(ggplot2)
library(caret)
library(plotly)
library(readxl)
library(rfm)
library(stats)
library(tidyverse)
library(factoextra)
library(NbClust)
library(gridExtra)

##### Função para carregar os dados da planilha Excel
carrega_dados <- function()
{
  setwd("C:/Users/Blazi/Documents/Data Science Academy DSA/Formação Cientista de Dados/Big Data Analytics com R e Microsoft Azure Machine Learning/Cap 6/Projeto Big Data 4")
  sheet1 <- read_excel('online_retail_II.xlsx', sheet = 'Year 2009-2010')
  sheet2 <- read_excel('online_retail_II.xlsx', sheet = 'Year 2010-2011')
  dados_combinados <- rbind(sheet1, sheet2)
  return(dados_combinados)
}

# Executar a função
dados <- carrega_dados()
dim(dados)
View(dados)

########### Função para checar valores ausentes
verifica_missing <- function(x)
{
  return(colSums(is.na(x)))
}

verifica_missing(dados)

############## Excluir os registros com valores ausentes

# Função para limpar e pré-processar os dados
preprocessa_dados <- function(data1)
{
  # Criando uma coluna chamada TotalPrice
  data1$TotalPrice <- data1$Quantity * data1$Price
  # Remove registros com valores ausentes
  data1 <- na.omit(data1)
  # Removemos as linhas da coluna Invoice que contém a letra C (o que significa que este pedido foi cancelado)
  data1 <- data1[!grepl("C",data1$Invoice),]
  
  return(data1)
}

# Executar a função com Dataset final
dataset <- preprocessa_dados(dados)
dim(dataset)
View(dataset)

################ Verificando a distribuição da variável Total Price
ggplot(dataset,
       aes(x = TotalPrice)) +
  geom_density(fill = "#69b3a2", color = "#e9ecef", alpha = 3.5) +
  labs(title = 'Distribuição da Variável TotalPrice')

# Número de clientes
length(dataset$`Customer ID`)
length(unique(dataset$`Customer ID`))

################## Total monetário gasto por cliente - concatenar colunas
total_gasto <- dataset %>%
  group_by(`Customer ID`) %>%
  summarise(Sum = sum(TotalPrice))

View(total_gasto)

################## Criando uma data customizada (Natal de 2011)

max(dataset$InvoiceDate)
date1 = as.Date.character("25/12/2011","%d/%m/%Y")

################## Função para converter as datas do formato POISxt para o formato Date
converte_data <- function(x)
{
  options(digits.secs = 3)
  return(as.Date(as.POSIXct(x$InvoiceDate, 'GMT')))
}

# Executa a função
dataset$InvoiceDate <- converte_data(dataset)
View(dataset)

##################### Função para calcular Recência, Frequência e Valor Monetário
calcula_rfm <- function(x){
  z <- x %>% group_by(`Customer ID`) %>% 
    summarise(Recency = as.numeric(date1 - max(InvoiceDate)), 
              Frequency = n(), 
              Monetary = sum(TotalPrice),
              primeira_compra = min(InvoiceDate))
## Removendo transações com valores acima do 3º Quartil e abaixo do Quartil 1 (removendo outliers)
Q1 <- quantile(z$Monetary, .25)
Q3 <- quantile(z$Monetary, .75)
IQR <- IQR(z$Monetary)
z <- subset(z, z$Monetary >= (Q1 - 1.5*IQR) & z$Monetary <= (Q3 + 1.5*IQR))
return(z)
}

# Executa a função
valores_rfm <- calcula_rfm(dataset)
View(valores_rfm)

write.table(valores_rfm, file = "Amostras_Tipos de Propriedade.csv", sep = ",", row.names = FALSE)


############################### Machine Learning - Clusterização Kmeans #######################

# Set seed
set.seed(1029)

############ Função para a segmentação de clientes com base nos valores RFM
segmenta_cliente <- function(rfm)
{
  # Cria uma lista
  resultados <- list()
  
  # Obtém os valores RFM
  dados_rfm <- select(rfm, c('Recency','Frequency','Monetary'))
  
  # Cria o modelo
  modelo_kmeans <- kmeans(dados_rfm, center = 5, iter.max = 50)
  
  # Plot do modelo
  resultados4$plot <- fviz_cluster(modelo_kmeans, 
                                  data = dados_rfm, 
                                  geom = c('point'), 
                                  ellipse.type = 'euclid')
  
  # Organiza os dados
  dados_rfm$`Customer ID` <- rfm$`Customer ID`
  dados_rfm$clusters <- modelo_kmeans$cluster
  resultados$data <- dados_rfm
  
  return(resultados)
}

###################### Plot
grafico <- segmenta_cliente(valores_rfm)[1]
grafico

tabela_rfm <- segmenta_cliente(valores_rfm)[2]
View(as.data.frame(tabela_rfm))

###################### Modelo refeito com 4 Segmentos/Clusters
######################
#####################

segmenta_cliente4 <- function(rfm)
{
  # Cria uma lista
  resultados4 <- list()
  
  # Obtém os valores RFM
  dados_rfm <- select(rfm, c('Recency','Frequency','Monetary'))
  
  # Cria o modelo
  modelo_kmeans4 <- kmeans(dados_rfm, center = 4, iter.max = 50)
  
  # Plot do modelo
  resultados4$plot <- fviz_cluster(modelo_kmeans4, 
                                  data = dados_rfm, 
                                  geom = c('point'), 
                                  ellipse.type = 'euclid')
  
  # Organiza os dados
  dados_rfm$`Customer ID` <- rfm$`Customer ID`
  dados_rfm$clusters <- modelo_kmeans4$cluster
  resultados4$data <- dados_rfm
  
  return(resultados4)
}

grafico4 <- segmenta_cliente4(valores_rfm)[1]
grafico4

tabela_Segmentção_de_Clientes_4_Clusters <- segmenta_cliente4(valores_rfm)[2]

###################### Modelo refeito com 3 Segmentos/Clusters
######################
#####################

segmenta_cliente3 <- function(rfm)
{
  # Cria uma lista
  resultados3 <- list()
  
  # Obtém os valores RFM
  dados_rfm <- select(rfm, c('Recency','Frequency','Monetary'))
  
  # Cria o modelo
  modelo_kmeans3 <- kmeans(dados_rfm, center = 3, iter.max = 50)
  
  # Plot do modelo
  resultados3$plot <- fviz_cluster(modelo_kmeans3, 
                                   data = dados_rfm, 
                                   geom = c('point'), 
                                   ellipse.type = 'euclid')
  
  # Organiza os dados
  dados_rfm$`Customer ID` <- rfm$`Customer ID`
  dados_rfm$clusters <- modelo_kmeans3$cluster
  resultados3$data <- dados_rfm
  
  return(resultados3)
}

grafico3 <- segmenta_cliente3(valores_rfm)[1]
grafico3

tabela_Segmentação_de_Clientes_3_Clusters <- segmenta_cliente3(valores_rfm)[2]
View(tabela_Segmentação_de_Clientes_3_Clusters)

### Nova tabela para relatórios

tabela <- as.data.frame(tabela_Segmentação_de_Clientes_3_Clusters$data)

str(tabela)
tabela$`Customer ID` <- as.character(tabela$`Customer ID`)
tabela$clusters <- as.factor(tabela$clusters)

#Renomar Clusters e reordenar tabela

tabela$clusters <- gsub('2', 'Premium', tabela$clusters)
tabela$clusters <- gsub('1', 'Intermediário', tabela$clusters)
tabela$clusters <- gsub('3', 'Básico', tabela$clusters)

levels(tabela$clusters) <- c('Premium', 'Intermediário','Básico')

tabela <- tabela[order(tabela$clusters, decreasing=FALSE),]

View(tabela)

### Agrupar por média dos valores dos Clusters e gerar segunda tabela

tabela_plot <- tabela %>% group_by(clusters) %>% summarise_at(vars(Recency, Frequency, Monetary), list(name = mean))

tabela_plot <- rename(tabela_plot, Segmento = clusters, Recência_Média = Recency_name, Frequência_Média = Frequency_name, Gasto_médio = Monetary_name)

View(tabela_plot)

# Salvando Tabelas

tabela <- rename(tabela, Segmento = clusters, Recência = Recency, Frequência = Frequency, Gasto = Monetary, 'ID do Cliente' = 'Customer ID')

write.table(tabela, file = "Segmentação.csv", sep = ",", row.names = FALSE)

write.table(tabela_plot, file = "Segmentação-Média_Geral.csv", sep = ",", row.names = FALSE)

# Plot

p1 <- ggplot(tabela_plot, aes(x = Segmento, y = Recência_Média, fill = Segmento)) +
  geom_col(aes(fill = Segmento), show.legend = FALSE, width = 0.40) + labs(x = "", y = 'Recência Média')

p2 <- ggplot(tabela_plot, aes(x = Segmento, y = Frequência_Média, fill = Segmento)) +
  geom_col(aes(fill = Segmento), show.legend = FALSE, width = 0.40) + labs(x = "", y = 'Frequência Média')

p3 <- ggplot(tabela_plot, aes(x = Segmento, y = Gasto_médio, fill = Segmento)) +
  geom_col(aes(fill = Segmento), show.legend = FALSE, width = 0.40) + labs(x = "", y = 'Gasto Médio')

grid.arrange(p1, p2, p3, ncol=3)

############################ Teste para descobrir número ideal de clusters

df_rfm <- select(valores_rfm, c('Recency','Frequency','Monetary'))

NbClust(data = df_rfm, distance = "euclidean",
        min.nc = 2, max.nc = 10, method = 'complete', index = "all")
