#!/bin/bash

# === Шаг 1: Проверяем наличие inventory.ini ===
if [ ! -f "inventory.ini" ]; then
  echo "Файл inventory.ini не найден. Убедитесь, что он существует."
  exit 1
fi

# === Шаг 2: Определяем список playbook'ов ===
PLAYBOOKS=(
  "playbooks/nginx.yml"
  "playbooks/prometheus.yml"
  "playbooks/grafana.yml"
  "playbooks/elasticsearch.yml"
  "playbooks/kibana.yml"
  "playbooks/filebeat.yml"
  "playbooks/webservers.yml"
)

# === Функция для запуска playbook'ов ===
run_playbook() {
  local playbook=$1
  echo "Запускаю playbook: $playbook"
  ansible-playbook -i inventory.ini "$playbook"

  # Проверяем код возврата
  if [ $? -ne 0 ]; then
    echo "Ошибка при выполнении playbook: $playbook"
    echo "Прерываю выполнение скрипта."
    exit 1
  fi
}

# === Основной цикл выполнения playbook'ов ===
for playbook in "${PLAYBOOKS[@]}"; do
  run_playbook "$playbook"
done

echo "Все playbook'ы успешно выполнены."