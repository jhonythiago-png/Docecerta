# Docecerta

App de acompanhamento diário de medicamentos, com login por conta (Supabase) — cada pessoa vê só os próprios dados.

## Arquivos deste pacote

- `index.html` — o app inteiro (interface + lógica + conexão com o Supabase)
- `manifest.json` — configuração para "adicionar à tela de início"
- `sw.js` — service worker (cache básico, sensação de app instalado)
- `icon-192.png`, `icon-512.png`, `apple-touch-icon.png` — ícones do app
- `supabase-schema.sql` — script para criar as tabelas no Supabase

## 1. Configurar o Supabase (uma vez só)

1. Entre no seu projeto em https://supabase.com/dashboard
2. Vá em **SQL Editor > New query**
3. Cole todo o conteúdo de `supabase-schema.sql` e clique em **Run**
4. Em **Authentication > Providers**, confirme que **Email** está habilitado
5. (Recomendado para começar rápido) Em **Authentication > Settings**, desligue
   "Confirm email" temporariamente — assim a conta já entra direto depois do
   cadastro, sem precisar clicar em link de confirmação. Pode reativar depois.

A URL e a chave pública (anon key) do seu projeto já estão embutidas no
`index.html` — não precisa mexer em mais nada de configuração.

## 2. Criar a conta da Poliana e restaurar o histórico

1. Abra o app, toque em **Criar conta**, cadastre o e-mail e senha dela
2. No Supabase, vá em **Authentication > Users**, copie o **User UID** que
   apareceu para essa conta
3. Volte no `supabase-schema.sql`, no bloco comentado no final do arquivo,
   troque `SEU_USER_ID_AQUI` por esse UID e rode esse bloco no SQL Editor
4. Isso preenche automaticamente o que já foi registrado: os dias 03 e 04/09
   e a aplicação de hoje da B12

## 3. Publicar no GitHub

```bash
cd docecerta
git init
git add .
git commit -m "Docecerta - primeira versão"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/docecerta.git
git push -u origin main
```

## 4. Colocar no ar (escolha uma opção)

**Opção A — GitHub Pages (mais simples, grátis)**
1. No repositório no GitHub, vá em **Settings > Pages**
2. Em "Source", escolha a branch `main` e a pasta `/ (root)`
3. Salve — em alguns minutos o link fica em algo como
   `https://seu_usuario.github.io/docecerta/`

**Opção B — Render (seu fluxo de sempre)**
1. Crie um **Static Site** apontando para o repositório `docecerta`
2. Build command: deixe em branco (não há build)
3. Publish directory: `.` (raiz do projeto)

## 5. "Instalar" no celular

Depois de publicado, abra o link no celular:
- **Android/Chrome**: menu (⋮) → "Adicionar à tela inicial"
- **iPhone/Safari**: botão de compartilhar → "Adicionar à Tela de Início"

O ícone do Docecerta aparece igual a um app normal, abrindo em tela cheia.

## Sobre múltiplos usuários

Hoje o regime de medicamentos (nomes, horários, frequências) é o mesmo para
qualquer conta — só o **registro de doses tomadas** e os **ajustes** (dia da
semana da vitamina D, referência dos dias alternados, início da B12) ficam
isolados por usuário. Se no futuro quiser vender pra outras pessoas com
regimes diferentes, o próximo passo natural é criar uma tela para cada
usuária cadastrar seus próprios medicamentos — hoje isso ainda é fixo no
código, pensado para o caso da Poliana.
