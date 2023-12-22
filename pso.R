#PROFESSOR CINIRO NAMETALA
#IFMG - CAMPUS BAMBUI
#OTIMIZACAO POR ENXAME DE PARTICULAS
#-------------------------------------------------------

#limpar workspace
rm(list=ls())

#limpar tela
cat('\014')

#bibliotecas
library("plot3D")


f.avaliacao <- function(ind) {
  # Critérios de penalização
  r <- 13
  s <- 16
  
  # Cálculo do fitness
  d <- length(ind)
  fx <- 10 * d + sum(ind^2 - 10 * cos(2 * pi * ind)) # Fitness do indivíduo #RASTRIGIN
  gx <- sum(r * pmax(0, sin(2 * pi * ind) + 0.5))   # gi(x) desigualdade
  hx <- sum(s * abs(cos(2 * pi * ind) + 0.5))        # hi(x0) igualdade
  px <- fx + gx + hx                                # Fitness com penalizações aplicadas
  
  fitnessCompleto <- px
  return(fitnessCompleto)
}

#FUNCOES
#ESFERA
#otimo: 0..
f.sphere <- function(x) 
{
  return(sum(x^2))
}

#RASTRIGIN
#otimo: 0..
f.rastrigin <- function(x)
{
  d <- length(x)
  sum <- sum(x^2 - 10*cos(2*pi*x))
  y <- 10*d + sum
  return(y)
}

#ROSENBROCK
#otimo: 1..
f.rosenbrock <- function(x)
{
  d <- length(x)
  xi <- x[1:(d-1)]
  xnext <- x[2:d]
  
  sum <- sum(100*(xnext-xi^2)^2 + (xi-1)^2)
  
  y <- sum
  return(y)
}

#-----------------------------------------------------------------------------

#PARAMETRIZACAO DO ALGORITMO
set.seed(84)
W <- 0.6                 #constante de inercia
C1 <- 1.4                #ponderacao do individuo (cognitiva)
C2 <- 1.7                #ponderacao global (social)

#PARAMETRIZACAO DO EXPERIMENTO
dimparticula <- 5          #quantidade de dimensoes do problema
funcaofit <- f.avaliacao  #funcao objetivo
maxiter <- 100             #quantidade maxima de iteracoes
qtdeparticulas <- 120     #quantidade de particulas
linf <- -5.12                 #limite inferior do espaco de busca
lsup <- 5.12                  #limite superior do espaco de busca

#EXIBICAO DE GRAFICOS
plotaGraficos <- TRUE

#GERANDO A MATRIZ DE PARTICULAS, VELOCIDADES E FITNESS INICIAL
#gera a matriz de posicoes das particulas
particulas <- matrix(
  runif(qtdeparticulas*dimparticula, linf, lsup), 
  qtdeparticulas, 
  dimparticula)

#gera o vetor de velocidades
velocidades <- matrix(
  runif(qtdeparticulas*dimparticula, 0, 1), 
  qtdeparticulas, 
  dimparticula)

#avalia a qualidade de cada particula com a funcao objetivo
fitness <- rep(NA,qtdeparticulas)
for (i in 1:qtdeparticulas)
{
  fitness[i] <- funcaofit(particulas[i,])
}

#DEFININDO PBEST DE CADA PARTICULA
pbest <- particulas

#IDENTIFICANDO GBEST DE TODAS AS PARTICULAS
indicegbest <- which(fitness == min(fitness))[1]
gbest <- particulas[indicegbest,]
fitnessgbest <- funcaofit(particulas[indicegbest,])

#vetor para armazenar a fitness media e a fitness do gbest a cada iteracao
fitnessmedia <- rep(NA,maxiter)
fitnessgbestiter <- rep(NA,maxiter)

if (plotaGraficos == TRUE)
{
  #plotando a funcoes
  x <- seq(linf,lsup,0.6)
  y <- x
  z <- matrix(NA, length(x), length(y))
  for (i in 1:length(x))
  {
    for (j in 1:length(y))
    {
      z[i,j] <- funcaofit(c(x[i],y[j]))
    }
  }
  
  persp3D(x,y,z,theta=45,phi=30)
  
  contour(x,y,z)
  par(new=T)
  
  #plotando as particulas
  plot(particulas, 
       xlim=c(linf,lsup), 
       ylim=c(linf,lsup), 
       pch=20, 
       xlab="", ylab="", col="blue", xaxt='n', yaxt='n')
}


#INICIALIZANDO O ALGORITMO
for (iter in 1:maxiter)
{
  print(iter)
  #movimenta as particulas no espaco
  for (i in 1:qtdeparticulas)
  {
    #calculando os tres vetores da formula de velocidade para particula i
    vetorinercia <- W*velocidades[i,]
    vetorlocal <- C1*(pbest[i,]-particulas[i,])
    vetorglobal <- C2*(gbest-particulas[i,])
    
    #atualiza velocidade da particula i
    velocidades[i,] <- vetorinercia + vetorlocal + vetorglobal
    
    #atualiza posicao da particula i
    particulas[i,] <- particulas[i,] + velocidades[i,]
    
    #avalia a fitness das particula i em sua nova posicao
    novafitness <- funcaofit(particulas[i,])
    
    #atualiza o vetor de fitness com a fitness da nova posicao
    fitness[i] <- novafitness
    
    #averigua se a nova posicao e melhor que a do pbest
    #se for, entao atualiza o pbest para a particula i
    if (novafitness < funcaofit(pbest[i,]))
      pbest[i,] <- particulas[i,]
  }
  
  #atualiza o gbest com base nas novas posicoes de todas as particulas
  if (min(fitness) < fitnessgbest)
  {
    indicegbest <- which(fitness == min(fitness))[1]
    gbest <- particulas[indicegbest,]
    fitnessgbest <- funcaofit(particulas[indicegbest,])
  }
  
  #guarda a fitness media da iteracao iter
  fitnessmedia[iter] <- mean(fitness)
  fitnessgbestiter[iter] <- fitnessgbest
  
  #plotando as particulas
  if (plotaGraficos == TRUE)
  {
    contour(x,y,z)
    par(new=T)
    plot(particulas, 
         xlim=c(linf,lsup), 
         ylim=c(linf,lsup), 
         pch=20, 
         xlab="", ylab="", col="blue")
  }
}

#exibi informacoes da melhor particula (ultimo gbest)
print(round(gbest, 4))
print(round(fitnessgbest,4))
plot(fitnessmedia, type="l", xlab="Iteracoes", ylab="Fitness media", main="Fitness media a cada iteracao")
plot(fitnessgbestiter, type="l", xlab="Iteracoes", ylab="Fitness", main="Fitness do gbest a cada iteracao")
