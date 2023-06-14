# Baixar imagem do cassandra
docker pull cassandra:latest

# Criar node-1 Errado
docker run --name cassandra-node1 -d cassandra:latest

# Crair node-1 Certo
docker run --name cassandra-node1 -v $PWD/cassandra-env.sh:/etc/cassandra/cassandra-env.sh -d cassandra:latest

# Criar node-2 e conectar containers ao container com node-1
docker run --name cassandra-node2 -v $PWD/cassandra-env.sh:/etc/cassandra/cassandra-env.sh -d --link cassandra-node1:cassandra cassandra:latest

# Definindo replicação para node-1
docker exec -it cassandra-node1 cqlsh -e "CREATE KEYSPACE replication WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 2};"
docker exec -it cassandra-node1 cqlsh -e "CREATE TABLE replication.users(id UUID PRIMARY KEY, name text, age int);"

# Verificar se tabela foi criada
docker exec -it cassandra-node1 cqlsh -e "SELECT * FROM replication.users;"

# Inserir dois usuários no node-1
docker exec -it cassandra-node1 cqlsh -e "INSERT INTO replication.users (id, name, age) VALUES (uuid(), 'Alice', 25);"
docker exec -it cassandra-node2 cqlsh -e "INSERT INTO replication.users (id, name, age) VALUES (uuid(), 'Bob', 30);"

# Update
docker exec -it cassandra-node1 cqlsh -e "UPDATE replication.users SET name = 'Fabio' WHERE id = <id>;"

# Delete
docker exec -it cassandra-node1 cqlsh -e "DELETE FROM replication.users WHERE id = <id>;"


# Verificar replicação
docker exec -it cassandra-node1 cqlsh -e "SELECT * FROM replication.users;"
docker exec -it cassandra-node2 cqlsh -e "SELECT * FROM replication.users;"

# Parar instancias
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

