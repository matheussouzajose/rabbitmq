FROM rabbitmq:3.12-management

LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="RabbitMQ with Delayed Message Exchange Plugin and Custom User"

# Definir variáveis de ambiente para usuário e senha
ENV RABBITMQ_DEFAULT_USER=admin
ENV RABBITMQ_DEFAULT_PASS=admin
ENV RABBITMQ_DEFAULT_VHOST=/

# Instalar dependências necessárias
RUN apt-get update && \
  apt-get install -y curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Baixar e instalar o plugin delayed message exchange
RUN curl -L https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.12.0/rabbitmq_delayed_message_exchange-3.12.0.ez > $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.12.0.ez

# Ativar os plugins necessários
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange rabbitmq_management

# Verificação de saúde
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD rabbitmqctl status || exit 1

# O RabbitMQ escuta nas seguintes portas por padrão
# 5672: porta principal AMQP
# 15672: interface de gerenciamento HTTP
# 15692: métricas para Prometheus
# 25672: distribuição para comunicação entre nós de cluster
EXPOSE 5672 15672 15692 25672

# O command/entrypoint padrão da imagem base já inicia o servidor corretamente