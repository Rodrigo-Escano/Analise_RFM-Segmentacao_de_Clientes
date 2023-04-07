# O que é Segmentação de Clientes?

A segmentação de clientes é a divisão de clientes e potenciais clientes de uma empresa em grupos que possuem características e dores semelhantes. Essa divisão contribui para a criação de campanhas direcionadas de marketing e vendas.

A segmentação torna a comunicação com leads, prospects e clientes, mais personalizada e eficiente, ao permitir separá-los em grupos menores, usando aspectos comuns entre eles. Ela oferece uma maneira simples de organizar e gerenciar os relacionamentos da empresa com os clientes.

Esse processo também facilita adaptar e personalizar os esforços de marketing, vendas e pós-vendas para as necessidades de grupos específicos, ajudando a aumentar a fidelidade e as conversões do cliente.

# O que é Análise RFM?

RFM significa Recência, Frequência e Valor Monetário (Recency, Frequency and Monetary Value) e implica na análise dos dados transacionais e para identificar diferentes segmentos de clientes com base em seu histórico de conversão. A Análise RFM é uma estratégia de marketing para analisar e estimar o valor de um cliente, com base em três fatores quantitativos:

• Recência

Quão recentemente um cliente fez uma compra?

• Frequência

Com que frequência um cliente faz uma compra?

• Valor Monetário

Quanto dinheiro um cliente gasta em compras?

A Análise RFM classifica numericamente um cliente em cada uma dessas três categorias, geralmente em uma escala de 1 a 5 (quanto maior o número, melhor o resultado). O “melhor” cliente receberá uma pontuação máxima em todas as categorias.

De acordo com essas métricas, é possível segmentar os clientes em grupos para entender quais deles compram muitas coisas com frequência, quais que compram poucas coisas, mas frequentemente, e os que não compram nada há muito tempo.

# Como foi feito?

Primeiro foi realizada limpeza dos dados originais, disponíveis no arquivo “online_retail_II”, descartando os outliers e valores ausentes, e em seguida foi calculado o score RFM utilizando o pacote “rfm” na linguagem R. Esses dados foram empregados para alimentar o modelo de segmentação usando Machine Learning com aprendizado não supervisionado.

O K-Means é um algoritmo de clusterização (ou agrupamento) disponível no pacote “factoextra” da linguagem R. É um algoritmo de aprendizado não supervisionado (ou seja, que não precisa de inputs de confirmação externos) que avalia e clusteriza os dados de acordo com suas características.

Todo o processo foi realizado na Linguagem R, e está presente no script “Projeto Análise RFM e Clusterização”.

# Resultados

O modelo de Cluster foi executado inicialmente com 5 categorias, como de padrão no mercado, porém o pacote “NbClust”, que fornece 30 índices para propor o melhor esquema de agrupamento/número de clusters, indicou que o melhor número de segmento seriam 3, baseado nos dados disponíveis. O modelo foi então refeito, com 3 clusters.

O algoritmo K-Means nomeia automaticamente os clusters os numerando (1,2,3) conforme presente no Gráfico de Segmentação de Clientes, porém esses números representam apenas nomes, não sendo a ordem hierárquica deles. Os clusters foram renomeados como “Premium”, “Intermediário” e “Menor” nos dois relatórios finais, e estão representados no Gráfico “Score RFM dos Segmentos”. Note que o componente Recência é o único que sendo menor é melhor, ou seja, significa que houve menos tempo desde que o cliente fez a última compra.
