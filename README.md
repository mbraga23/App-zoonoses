# Zoonoses App

Aplicativo Flutter offline-first para registrar o Serviço Antivetorial de zoonoses em campo.

## Estrutura do projeto
- **lib/domain**: entidades e contratos de repositórios.
- **lib/data**: modelos, adapters e implementações de repositórios usando **sqflite**.
- **lib/presentation**: telas, widgets e providers **Riverpod**.
- **assets/data/seed.json**: carga inicial de agentes, zoneamentos e ruas.

## Principais telas e fluxos
- **Tela inicial**: Login é a primeira tela exibida (rota `/`).
- **Login**: seleção de agente (username) e zoneamento obrigatórios. Atualiza o zoneamento ativo do agente, registra log interno ao mudar e encaminha para a lista principal.
- **Lista de registros**: mostra registros do zoneamento ativo, permite trocar zoneamento e criar novo registro diário.
- **Formulário de registro diário**: coleta dados do imóvel/ponto, situação, tipo de atividade, focos, tratamento e observações.
- **Exportação**: filtra por período/zoneamento e gera PDF (com cabeçalho e tabela) ou CSV salvo localmente, com opção de compartilhar PDF.

## Tecnologias
- **Flutter** com null-safety.
- **State management**: `flutter_riverpod`.
- **Banco local**: `sqflite` + `path_provider` (seed via JSON).
- **Geração de arquivos**: `pdf`, `printing` (visualização/compartilhamento) e `csv`.

## Como rodar
1. Instale Flutter (canal estável).
2. Execute `flutter pub get` para baixar dependências.
3. Rode `flutter run` em um dispositivo/emulador Android ou tablet.

### Fluxo de login
1. Abrir o app exibe a tela de login.
2. Preencher o nome do agente e escolher o zoneamento (dados carregados do seed/local).
3. Tocar em **Entrar** salva/atualiza o agente com zoneamento ativo e navega para a lista de registros.

## Pontos preparados para futura sincronização
- Interface `RemoteSyncService` em `lib/data/adapters/remote_sync_service.dart` pode receber implementação REST futura.
- Repositórios locais seguem contratos na camada domain para que versões remotas possam ser adicionadas e combinadas.

## Observações
- O app funciona totalmente offline; dados ficam no SQLite local.
- Logs de troca de zoneamento são salvos na tabela `zone_change_logs` para auditoria, sem UI dedicada.
