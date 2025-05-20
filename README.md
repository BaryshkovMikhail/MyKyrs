# MyKyrs


terraform init
terraform plan
terraform apply


for playbook in prometheus grafana elasticsearch kibana filebeat; do   ansible-playbook -i ../hosts.ini playbooks/${playbook}.yml; done

ansible-playbook -i ../hosts.ini playbooks/common_docker.yml

Запустите playbooks в правильном порядке:
bash

ansible-playbook -i ../hosts.ini playbooks/common_docker.yml
ansible-playbook -i ../hosts.ini playbooks/elasticsearch.yml
ansible-playbook -i ../hosts.ini playbooks/kibana.yml
ansible-playbook -i ../hosts.ini playbooks/prometheus.yml
ansible-playbook -i ../hosts.ini playbooks/grafana.yml
ansible-playbook -i ../hosts.ini playbooks/filebeat.yml
ansible-playbook -i ../hosts.ini playbooks/nginx.yml

Для проверки работы Docker после common_docker.yml можно выполнить:
bash

ansible all -i ../hosts.ini -m command -a "docker --version"