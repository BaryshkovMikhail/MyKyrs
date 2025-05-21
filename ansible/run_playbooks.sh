#!/bin/bash

# Скрипт для последовательного запуска Ansible playbook'ов

# Определяем путь к inventory-файлу
INVENTORY="../hosts.ini"

# Обновленный список playbook'ов для выполнения в нужном порядке
PLAYBOOKS=(
  "playbooks/webservers.yml"     # Объединяет nginx + базовые экспортеры
  "playbooks/elasticsearch.yml"
  "playbooks/kibana.yml"
  "playbooks/prometheus.yml"
  "playbooks/grafana.yml"
  "playbooks/filebeat.yml"
)

# Функция для запуска playbook с проверкой результата
run_playbook() {
  local playbook=$1
  echo "Запускаем playbook: $playbook"
  ansible-playbook -i "$INVENTORY" "$playbook"
  
  # Проверяем код возврата
  if [ $? -ne 0 ]; then
    echo "Ошибка при выполнении playbook: $playbook"
    echo "Прерываем выполнение скрипта."
    exit 1
  fi
}

# Основной цикл выполнения playbook'ов
for playbook in "${PLAYBOOKS[@]}"; do
  run_playbook "$playbook"
done

echo "Все playbook'ы успешно выполнены."