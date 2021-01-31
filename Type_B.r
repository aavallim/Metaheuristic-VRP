rm(list =ls())

# _____________________________________________________________________
# _____________________________________________________________________
# _____________________** MODELAGEM TIPO II **_________________________
# _____________________________________________________________________
# _____________________________________________________________________

#                  --- VETOR de Dimens�o = N_pontos  ---
# ---  Cada posi��o do vetor define a Rota a que o Ponto foi alocado  ---
#  ---  Cada posi��o do vetor (vari�vel) varia entre 1 e N_veiculos  ---

# ***********************************************************************

# EXEMPLOS: Vetores com 10 e 100 pontos / 3 e 10 Ve�culos

# ------------ Cria o caminho para o diret�rio do Script
sFolder = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(sFolder))

#   --------------- INICIALIZA��O - VETOR INICIAL ----------------
# V <- rep(1:3, each=3)
# vetor<- append(V, 3, after = 9)

bVetor_100 = TRUE
N_populacao <- 10
N_iteracoes <- 50

if (bVetor_100) {
  
  V <- rep(1:10, each=10)
  N_pontos<-100
  N_veiculos<-10
  
  # ------------------ LEITURA das COORDENADAS dos PONTOS
  # ....... Faz a Leitura de um Total de Pontos = (N_pontos + N_veiculos)
  Pontos_Coord <- read.csv2("Data/110pontos.csv",header=TRUE,sep=";")
  
} else {
  
  V <- rep(1:3, each=3)
  N_pontos<-10
  N_veiculos<-3
  Pontos_Coord <- read.csv2("Data/13pontos.csv",header=TRUE,sep=";")
  
}

vetor <- V
N_vetor<-length(vetor)


length(vetor)
vetor

Vetor_veiculos <- 0
for (i in 1:N_veiculos) Vetor_veiculos[i] <- N_pontos + i
Vetor_veiculos

#       ------------------- FUN��O PRINCIPAL  -----------------------
#        --- Blocos de C�digo dentro de uma Fun��o Principal  ---
#                  --- VETOR de Dimens�o = N_pontos  ---
#   ---  Cada posi��o do vetor (vari�vel) varia entre 1 e N_veiculos  ---
#  ---  Cada posi��o do vetor define a Rota a que o Ponto foi alocado  ---
# ***********************************************************************
#

#                  ********** ATEN��O **********
# **** AQUI QUE SE D� <CTRL> <ENTER> para uso da Modelagem II ******
f_Obj_Meta3<- function(x){
  
  # ########################### FUN��ES ###################################
  
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 01 - IN�CIO -----------------------
  # ***********************************************************************
  
  # BLOCO No. 01 - Recebe vetor "x" da metaheuristica (Vetor Permutado)
  
  # Recebe vetor "x" da metaheuristica
  # Arredonda valores de "x" para o Inteiro mais pr�ximo
  # Varia entre 1 e N_veiculos
  x
  x_ajustado <- (x + 0.5)
  x_ajustado
  
  vetor_permutado <- as.integer(x_ajustado)
  vetor_permutado
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 02 - IN�CIO ---------
  # ***********************************************************************
  # BLOCO No. 02 - Ordem dos Pontos no Vetor por Sequ�ncia de Rotas
  #     O vetor est� na sequ�ncia das Rotas: rota 1, rota 2, ....rota n
  #   O valor de cada posi��o do Vetor � o No. do Ponto que est� na Rota
  #  Ele apresenta os Pontos da Rota 1, Pontos da Rota 2....Pontos da Rota n
  
  pos_rota_ord<-order(vetor_permutado)
  pos_rota_ord
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 03 - IN�CIO -----------------------
  # ***********************************************************************
  
  # ---------BLOCO No. 03 - CRIA��O de um VETOR de ROTAS -------------------
  # Transformar Vetor Permutado ( pos_rota_ord) para uma Sequencia de Rotas
  # O vetor tem uma sequ�ncia do tipo: Rota 1, Rota 2, ..... Rota n
  # O n�mero da rota aparece tantas vezes quantos forem os No. de Ptos/rota
  
  vetor_rota<-0
  for (i in 1:N_vetor) vetor_rota[i] <- vetor_permutado[pos_rota_ord[i]]
  vetor_rota
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 04 - IN�CIO -----------------------
  # ***********************************************************************
  # ---- BLOCO No. 04 ----
  # ---- Identifica Posi��o de In�cio de cada Rota no Vetor de Rotas ----
  
  pos_vetor_rota<-0
  for (i in 1:N_veiculos) {
    pos_vetor_rota[i] <-0  }
  pos_vetor_rota
  
  for (j in 1:N_veiculos) {
    for (i in 1:N_vetor) {
      if (vetor_rota[i] == j)
        pos_vetor_rota[j] <- i  } }
  pos_vetor_rota  
  
  # AJUSTE das POSI��ES para os casos em que n�o h� rota para um Ve�culo
  # Nestes casos a posi��o do ve�culo � incializada com ZERO
  # Aqui faz-se este ajuste: troca-se o 0 pelo valor da Posi��o Anterior
  for (i in 2:(N_veiculos-1)) {
    if (pos_vetor_rota[i] == 0) pos_vetor_rota[i]<- pos_vetor_rota[i-1]
  }
  if (pos_vetor_rota[N_veiculos] == 0) pos_vetor_rota[N_veiculos]<- N_vetor
  pos_vetor_rota
  
  
  # ***********************************************************************
  #     ------------------- BLOCOS No. 05 - IN�CIO -----------------------
  
  # -----     BLOCO No. 05 - CRIA ROTAS em "GOTAS" (CIRCULARES)   -----
  # ... Todas as rotas iniciam e terminam no Ponto de Origem 
  #   Todas formam um circuito...ficam no formato de uma "GOTA"
  #   Todas as rotas ficam em forma de Gota no pr�prio Vetor de Rotas
  # Acrescenta-se Ponto de Origem no In�cio/Final das Rotas (forma a GOTA)
  # -----------------------------------------------------------------
  
  # --- Cria e Inicializa um Vetor Circular com Rotas em Gotas (rotas Circulares)
  # ............   Vetor Circular Inicial = Vetor "pos_rota_ord"    ........
  vetor_rota_circ <- pos_rota_ord
  vetor_rota_circ
  
  # -----     CRIA ROTAS em "GOTAS" (CIRCULARES)   -----
  # ------- Acrescenta Ponto de Origem ao In�cio/Fim de cada Rota
  
  ## *********************** ATEN��O:
  # ==>> pos_rota_ord = Posi��es dos Ve�culos no Vetor Permutado Inicial
  # ==>> pos_vetor_rota = Posi��es de Ve�cs no Vetor Circular
  
  j=0
  for (i in N_veiculos:1) {
    vetor_rota_circ<- append(vetor_rota_circ,N_pontos+N_veiculos-j, after = pos_vetor_rota[i])
    if (i !=1){
      vetor_rota_circ<- append(vetor_rota_circ,N_pontos+N_veiculos-j, after = pos_vetor_rota[i-1])
    }
    j <- j+1
  }
  vetor_rota_circ<- append(vetor_rota_circ,Vetor_veiculos[1], after = 0)
  vetor_rota_circ
  
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 06 - IN�CIO -----------------------
  # ***********************************************************************
  
  # BLOCO No. 06 - Identifica In�cio/Fim das Rotas no Vetor de Rotas em Gotas
  #                Limites das Rotas 
  # -----          Identifica tamb�m o No. de Pontos em cada Rota    ------
  
  Limites_Rota_circ<-matrix(ncol = 4, nrow = N_veiculos)
  Pontos_na_Rota <- 0
  for (i in 1:N_veiculos){
    Limites_Rota_circ[i,1] <- N_pontos + i #  .....No. da Rota
    Limites_Rota_circ[i,2] <- which(vetor_rota_circ == N_pontos+i)[1] # ...In�cio
    Limites_Rota_circ[i,3] <- which(vetor_rota_circ == N_pontos+i)[2] # ...Fim
    Limites_Rota_circ[i,4] <-  Limites_Rota_circ[i,3] -  Limites_Rota_circ[i,2]
  }
  Limites_Rota_circ
  Maior_rota <- max(Limites_Rota_circ[,4])
  Maior_rota
  vetor_rota_circ
  
  
  # ***********************************************************************
  #     ------------------- BLOCO No. 07 - IN�CIO -----------------------
  #         BLOCO No. 07 - CALCULA DIST�NCIAS - "Fun��o Objetivo"
  # ***********************************************************************
  
  # Fun��o Preliminar: C�lculo de DisT�ncia Euclideana entre dois Pontos
  Dist <- function(XA, YA, XB, YB){
    D_AB <- sqrt((XA-XB)**2+(YA-YB)**2)
    return(D_AB)
  }
  
  # BLOCO No. 07 - CALCULA DIST�NCIAS - "Fun��o Objetivo"
  # Tr�s sa�das do Bloco No. 07:  . Vetor de Dist�ncias por Trecho por Rota
  #                               . Vetor de Dist�ncias Totais por Rota e
  #                               . Dist�ncia Global
  
  # .... INICIALIZA��O ......
  # ... Dimensiona Matriz de Dist�ncias pela Rota com maior No. de Pontos
  Distances_Vetor <- matrix(nrow = N_veiculos, ncol = Maior_rota)
  
  # ... Inicializa Dist�ncia Total de cada Rota
  Distance_Rota <- 0 
  for (i in 1:N_veiculos) Distance_Rota[i] <- 0
  
  # .... C�LCULOS de DIST�NCIAS......chama Fun��o <Dist() >
  for (i in 1:N_veiculos){
    for (j in 0:Limites_Rota_circ[i,4]){
      Dist_AB <- Dist (Pontos_Coord$X[vetor_rota_circ[Limites_Rota_circ[i,2]+j]], 
                       Pontos_Coord$Y[vetor_rota_circ[Limites_Rota_circ[i,2]+j]],
                       Pontos_Coord$X[vetor_rota_circ[Limites_Rota_circ[i,2]+j+1]],
                       Pontos_Coord$Y[vetor_rota_circ[Limites_Rota_circ[i,2]+j+1]] ) 
      if (j < Limites_Rota_circ[i,4]){
        Distances_Vetor[i,j+1] <- Dist_AB 
        Distance_Rota[i] <- Distance_Rota[i] + Distances_Vetor[i,j+1]
      }
    }
  }
  
  # ------------ C�LCULO de DIST�NCIA GLOBAL ==>> FUN��O OBJETIVO ------------
  Distance_Global <- 0
  for (i in 1:N_veiculos) Distance_Global <- Distance_Global + Distance_Rota[i]
  Distances_Vetor
  Distance_Rota
  Distance_Global
  
  Len_routes<- length(vetor_rota_circ)
  Rotas_e_Dist<- append(vetor_rota_circ, round(Distance_Global, digits =1), after = Len_routes)
  
  sFolder = rstudioapi::getActiveDocumentContext()$path
  setwd(dirname(sFolder))
  
  # OK!!!!! ***** O APPEND Funciona com o comando write.table() abaixo: *******
  write.table(round(Distances_Vetor, digits = 1), "./Output/Distancias_por_Trecho_de_Rota3.csv", sep = ";",
              col.names = !file.exists("./Output/Distancias_por_Trecho_de_Rota3.csv"), append = T)
  
  write.table(round(Distance_Rota, digits = 1), "./Output/Distancias_por_Rota3.csv", sep = ";",
              col.names = !file.exists("./Output/Distancias_por_Rota3.csv"), append = T)
  
  write.table(round(Distance_Global, digits = 2), "./Output/Distancia_Global3.csv", sep = ";",
              col.names = !file.exists("./Output/Distancia_Global3.csv"), append = T)
  
  write.table(Rotas_e_Dist, "./Output/Rotas_Circulares3.csv", sep = ";",
              col.names = !file.exists("./Output/Rotas_Circulares3.csv"), append = T)
  
  write.table(Limites_Rota_circ, "./Output/Pontos_por_Rota3.csv", sep = ";",
              col.names = !file.exists("./Output/Pontos_por_Rota3.csv"), append = T)
  
  # ***********************************************************************
  #     ------------------- BLOCOS 1 a 7 - FIM -----------------------
  # ***********************************************************************
  
  
  # ***********************************************************************
  #     -------------RETORNO da FUN��O OBJETIVO -----------------------
  # ***********************************************************************
  # return( list(Aloca��o_de_Rotas_por_Ponto_do_Vetor = vetor_permutado,
  #              Pontos_por_Sequ�ncia_das_Rotas_no_Vetor = pos_rota_ord,
  #              Vetor_com_as_Rotas_em_Sequencia = vetor_rota,
  #              Qtde_de_Veiculos = N_veiculos,
  #              Numeros_dos_Veiculos = Vetor_veiculos,
  #              Vetor_de_Rotas_Circulares_GOTAS = vetor_rota_circ,
  #              Posi��es_de_In�cio_Fim_das_Rotas_em_Gotas = Limites_Rota_circ,
  #              No._de_Pontos_por_Rota_em_Gota = Limites_Rota_circ[,4],
  #              Vetores_de_Dist�ncias_por_Rota = Distances_Vetor,
  #              Dist�ncias_Totais_por_Rota = Distance_Rota,
  #              Dist�ncia_GLOBAL_da_OPERA��O = Distance_Global))
  
  return(Distance_Global) # .... Para a META retorna s� a F. Obj.
  
}  # ..... Chave da FUN��O

# ***********************************************************************
# ----------- APLICA��O da FUN��O ABC para MODELAGEM TIPO II ------------
# ***********************************************************************

# FUN��O ABC() ===>>>> para F.OBJ_META3
#   ***** ATEN��O: ANTES DE RODAR ESTA MH, RODA-SE A F.OBJ_META3 *******

# install.packages(metaheuristicOpt)
library(metaheuristicOpt)
## INICIALIZA��O: Defini��o de Par�metros da ABC (numVar e rangeVar)
numVar <- N_pontos
numVar

rangeVar<- matrix(nrow= 2, ncol=N_pontos)
for (i in 1:2){
  for (j in 1:N_pontos){
    rangeVar[1,j] <- as.integer(1)
    rangeVar[2,j] <- as.integer(N_veiculos)
  }}
rangeVar


## C�LCULO da SOLU��O �TIMA por ABC - Artificial Bee Colony algorithm
Solucao_ABC <- ABC(f_Obj_Meta3, optimType="MIN", numVar, numPopulation=N_populacao,
                   maxIter=N_iteracoes, rangeVar)
Solucao_ABC   # ... Vetor de n�meros REAIS com No.s das Rota de cada Ponto

Rotas_Solucao.Otima_ajustada <- as.integer(Solucao_ABC + 0.5)
Rotas_Solucao.Otima_ajustada  # ... Vetor de n�meros INTEIROS com No.s das Rota de cada Ponto

## RESULTADOS da SOLU��O �TIMA usando a Fun��o META3
Solucao.Otima <- f_Obj_Meta3(Rotas_Solucao.Otima_ajustada)
round(Solucao.Otima, digits=2)
#...... VIDE RESULTADOS nos ARQS .CSV GRAVADOS .......
# -----------------------------------------------------------------------