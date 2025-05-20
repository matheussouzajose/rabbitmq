FROM rabbitmq:3.12-management

# Habilita o plugin de delayed messages
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

# Copia o arquivo de configuração customizado
COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf