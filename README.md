# PSO - Otimização por Enxame de Partículas

## Descrição
A otimização por enxame de partículas (PSO) é uma técnica de otimização baseada em uma estratégia inspirada no voo de pássaros e no movimento de cardumes de peixes. Este método permite a otimização global de uma função objetivo em um espaço multidimensional. As partículas no enxame são utilizadas para explorar o espaço de busca em busca do ótimo global.

## Funcionalidades
- Aplicação do algoritmo para encontrar o ótimo em uma função objetivo específica.

## Problema Aplicado
O problema específico abordado neste código é a otimização da função Rastrigin com restrições em n dimensões. A função objetivo é dada por:
        min f(x) = 10n + Σ [xᵢ² - 10cos(2πxᵢ)]
onde:
- n é o número de dimensões.
- xᵢ são as variáveis de decisão.

## Restrições do Espaço de Busca
As variáveis de decisão xᵢ estão sujeitas à restrição:
-5.12 ≤ xᵢ ≤ 5.12, para i = 1, 2, ..., n

## Conjunto Ótimo
O conjunto ótimo é dado por:
x* = [-1/3, -1/3, -1/3, ..., -1/3]
