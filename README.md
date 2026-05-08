# 2026-303-The-Last-Egg

## Grupo
- Arthur Fernando
- Arthur Guedes
- Davi Elias
- Francisco Almeida
- Marcelo Pezzini
- Samuel Hanry

## O último ovo


O jogo "O último ovo" retrata a jornada do pássaro Falco em busca de restaurar a sua espécie que esta em risco de extinção. Durante a jornada Falco vai passar por vários desafios como derrotar predadores e conquistar territórios para impedir que sua espécie seja extinta.

## Planilha de Acessibilidade
https://docs.google.com/spreadsheets/d/1hMr2mcNMs9up31D6zCn5308dHRLsqw0JQCNbnnlR_M4/edit?gid=107741830#gid=107741830

## Tecnologias
- Godot Engine (4.5 Stable)

## Pré-requisitos
- Godot Engine (4.5 Stable)
  
## Ferramentas de Desenvolvimento
- Aseprite (para criação de sprites e animações)

## Tela Inicial 
<img src="imgs/TelaInicial_TheLastEgg.png" alt="Logo">

<img src="gif/AnimaçãoOvo.gif" alt="Animação">

- Na tela inicial do nosso jogo possui uma animação curtinha feito no aplicativo Aseprite com uma música tocando de fundo e com efeitos sonoros para cada frame da animação.
- Você pode acessar o nosso menu apertando o espaço.

## Menu Principal
<img src="imgs/MenuPrincipal_TheLastEgg.png" alt="Logo">

 O menu principal apresenta três botões, cada um deles apresenta diferentes funcionalidades:</p>

  - **Jogar:** Inicia o jogo, porém atualmente ele ainda não possui os elementos do projeto final, sendo apenas um placeholder.
  - **Configurações:** Leva ao painel de configurações do jogo.
  - **Sair:** Faz sair do jogo

## Configurações
<img src="imgs/Configurações_TheLastEgg.png" alt="Logo">

Nas configurações possuímos apenas a configuração do volume. Realmente ficou a desejar em termos de acessibilidade, mas as configurações possuem um arquivo singleton/global que salva suas preferências mesmo após o fechamento do jogo. Possui alguns botões de teste para verificar se o volume funciona (obs: funciona de verdade :) ).

## Divisão de Trabalho

- Arthur Guedes → Programação e Animação  
- Davi Elias → Preenchimento da GDC e README  
- Francisco → Preenchimento da GDC e Slides  
- Arthur Fernando → Programação e Commits  
- Samuel → História e Design  
- Marcelo → Design da GDC  

## Avisos para modificação e/ou debug

Para executar o nosso projeto é necessário seguir alguns procedimentos para funcionar.

- Infelizmente é preciso ter o Aseprite no pc e o plugin do Wizard Aseprite para executar a nossa intro. Como o tutorial para baixar o plugin é bastante extenso, tem um vídeo brasileiro ensinando a como instalar corretamente: https://www.youtube.com/watch?v=1eqbsRNeNos&pp=ygUWYXNlcHJpdGUgd2l6YXJkIGdvZG90IA%3D%3D.
  
- No nosso jogo possui um sistema de saves da configuração, ou seja , é preciso localizar o arquivo global que é ConfigFileHandler no caminho res://Singletons/ConfigFileHandler.gd para que as configurações sejam salvadas e carregadas adequadamente. Para colocar um arquivo global vc vai em Projeto -> configurações Do Projeto -> Globais e depois adicionar o caminho e o arquivo.

- O sistema de BUS(canais de aúdio) é preciso configurar para o caminho correto. Para isso vc vai em Projeto -> Geral -> Áudio -> Layout Padrão de Canais e coloque esse caminho: res://BUS/default_bus_layout.tres.

- Caso não consegue executar mesmo seguindo esses passos, pfvr me contata.
  
## Slides

Slides: https://canva.link/0gx7ckfm0sdpbou


