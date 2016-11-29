# Demo




#### Mise en place de l'environnement 

1-  Creation des noeuds [01-04]

```sh
for id in $(seq -f "%02g" 1 4) ;do 
  echo "==> Creating node-$id"; 
  docker-machine create node-$id --driver virtualbox; 
  echo "==> Done."; 
done
```

2. Lister les machines : 

```sh
docker-machine ls
````

3. Charger l'environnement de chaque machine : 

```sh
eval "$(docker-machine env <NAME>)"
```

4. Lancer Ansible sur node-01 : 

```sh
# Rcuperation du repo ansbile 
git clone git@github.com:Stores-Discount/ansible-playbooks.git

# jump dans le dossier
cd ansible-playbooks/

# Lancer le conteneur ansible avec pour volum le repertoire courant
docker run -it -d  -v "${PWD}:/etc/ansible" --name manager  ansible/ansible:ubuntu1404
```

5. Copie des clefs des autres node-0[2-4] vers le conteneur manager.
```sh
for id in $(seq -f "%02g" 2 4) ;do  
    echo "==> Transfer ssh keys of node-$id to <manger> container on node-01"; 
    docker cp  $(docker-machine inspect -f "{{.Driver.SSHKeyPath}}" node-$id)  manager:/root/.ssh/node-$id-id_rsa ; 
    echo "==> Done."; 
done
```   

6. Test de connexion aux noeuds 02, 03, 04 depuis le conteneur manager:
```sh
# Utiliser la commande suivante depuis l'hôte pour récuperer l'ip de la machine <NODE-IP>:
#   $: docker-machine ip <NAME>
#   Ex: docker-machineip node-02 #=> 192.168.99.102
ssh   -i /root/.ssh/<NAME>-id_rsa  docker@<NODE-IP> "echo connected"
``` 

7. Installer Ansible et ses dépendances :
```sh
pip install ansible docker-py docker-compose
```

