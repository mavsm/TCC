# TCC
Projeto de Conclusão de Curso

Tema - Geração procedural

  Um problema comum econtrado em alguns jogos que usam geração procedural é, devido a grande variancia de conteúdo que pode ser gerado, tal conteúdo pode tanto ser do gosto do jogador quanto o contrário. Assim,
neste projeto se propõe desenvolver um jogo em que, com input do jogador, o conteúdo mude para algo mais prazerozo ao jogador.
O jogo desenvolvido será um simples jogo top-down onde o jogador, controlando seu personagem, completa pequenas dungeons ao chegar à sua saída e derrotar inimigos. Cada uma destas dungeons é composta por um único
andar cujo layout (paredes, posições de inimigos, posições de saída e entrada) é completamente gerado proceduralmente.
A cada dungeon completa o jogador deve dar uma nota para algumas qualidades desta dungeon (expansividade, dificuldade) e então selecionar uma dessas qualidades em que a geração da próxima dungeon deve focar. Assim,
similar a um algoritmo genético, os parâmetros de geração serão modificados de modo que a próxima dungeon gerada espera receber uma nota maior ou igual a anterior na qualidade selecionada.

Sobre o repositório:
  Na pasta TestesGeração se encontram arquivos de processing que contém geradores de nível, usados para fácil visualização de seus resultados, assim facilitando a escolha do gerador a ser usado no produto final.
