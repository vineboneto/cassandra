# Baixar imagem do cassandra
docker pull cassandra:latest

# Criar node-1
docker run --name cassandra-node1 -d cassandra:latest

# Criar node-2 e node-3 e conectar containers ao container com node-1
docker run --name cassandra-node2 -d --link cassandra-node1:cassandra cassandra:latest
docker run --name cassandra-node3 -d --link cassandra-node1:cassandra cassandra:latest

