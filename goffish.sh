###### Download Giraph and use release 1.2 #######
eval git clone https://github.com/apache/giraph.git
cd giraph
eval git checkout release-1.2


###### Patch for the root POM #######
change='<munge.symbols>PURE_YARN</munge.symbols>'
eval sed -i '1269s@.*@$change@' pom.xml
change='<version>\${hadoop.version}</version>'
eval sed -i '1279a$change' pom.xml
eval sed -i '1284a$change' pom.xml
eval sed -i '1289a$change' pom.xml
change='<module>goffish-giraph</module><module>goffish-api</module>'
eval sed -i '2259a$change' pom.xml


# ###### Patch for the root POM #######
# change='<munge.symbols>PURE_YARN</munge.symbols>'
# eval sed -i '1270s@.*@$change@' pom.xml
# change='<version>\${hadoop.version}</version>'
# eval sed -i '1280a$change' pom.xml
# eval sed -i '1285a$change' pom.xml
# eval sed -i '1290a$change' pom.xml
# change='<module>goffish-giraph</module><module>goffish-api</module>'
# eval sed -i '2271a$change' pom.xml


###### Download GoFFish #######
cd ..
eval git clone https://github.com/dream-lab/goffish_v3.git


###### Use of GoFFish on top of Giraph
cp -rt giraph/ goffish_v3/goffish-api goffish_v3/giraph/goffish-giraph
eval patch giraph/giraph-core/src/main/java/org/apache/giraph/job/GiraphConfigurationValidator.java goffish_v3/giraph/GiraphConfigurationValidator.patch



###### adjustments in GoFFish #######
change='//'
eval sed -i '43s@.*@$change@' giraph/goffish-api/src/main/java/in/dream_lab/goffish/api/IVertex.java
mkdir giraph/goffish-giraph/src/test/
cp -rt giraph/goffish-giraph/src/test/ giraph/goffish-giraph/src/main/java



###### Build GoFFish-Giraph #######
cd giraph
# eval mvn -Phadoop_yarn -Dhadoop.version=2.7.2 -DskipTests clean package
eval mvn -Phadoop_yarn -Dhadoop.version=2.7.4 -DskipTests clean package
cd ..


####### Run an example #######
# hadoop jar giraph/goffish-giraph/target/goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner -D giraph.metrics.enable=true in.dream_lab.goffish.giraph.graph.GiraphSubgraphComputation -vif org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat -vip /user/vishak/1 -vof org.apache.giraph.io.formats.IdWithValueTextOutputFormat -op /user/vishak/out -yj goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar -mc in.dream_lab.goffish.giraph.master.SubgraphMasterCompute -w 4 -yh 4000 -ca giraph.SplitMasterWorker=false

#hadoop jar giraph/goffish-giraph/target/goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner -Dgiraph.metrics.enable=true in.dream_lab.goffish.giraph.graph.GiraphSubgraphComputation -eif org.apache.giraph.io.formats.IntNullTextEdgeInputFormat -vip /user/vishak/inp/data -vof in.dream_lab.goffish.giraph.formats.SubgraphSingleSourceShortestPathOutputFormatSir -op /user/vishak/out -ca giraph.subgraphVertexValueClass=org.apache.hadoop.io.DoubleWritable,subgraphSourceVertex=1,giraph.subgraphMessageValueClass=org.apache.hadoop.io.BytesWritable,giraph.outgoingMessageValueFactoryClass=in.dream_lab.goffish.giraph.factories.DefaultSubgraphMessageFactory,giraph.messageEncodeAndStoreType=POINTER_LIST_PER_VERTEX,giraph.clientSendBufferSize=20000000,giraph.clientReceiveBufferSize=20000000,giraph.graphPartitionerFactoryClass=in.dream_lab.goffish.giraph.factories.SubgraphPartitionerFactory,giraph.subgraphValueClass=org.apache.hadoop.io.LongWritable,giraph.vertexClass=in.dream_lab.goffish.giraph.graph.DefaultSubgraph,subgraphComputationClass=in.dream_lab.goffish.giraph.examples.SingleSourceShortestPath,giraph.edgeValueClass=org.apache.hadoop.io.DoubleWritable,giraph.vertexIdClass=in.dream_lab.goffish.giraph.graph.SubgraphId,giraph.vertexValueClass=in.dream_lab.goffish.giraph.graph.SubgraphVertices,giraph.outgoingMessageValueClass=in.dream_lab.goffish.giraph.graph.SubgraphMessage -yj goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar -mc in.dream_lab.goffish.giraph.master.SubgraphMasterCompute -w 1 -ca giraph.SplitMasterWorker=false





















































#hadoop jar giraph/goffish-giraph/target/goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner -Dgiraph.metrics.enable=true in.dream_lab.goffish.giraph.graph.GiraphSubgraphComputation -vif in.dream_lab.goffish.giraph.formats.LongDoubleDoubleAdjacencyListSubgraphInputFormat -vip /inp/ -vof in.dream_lab.goffish.giraph.formats.SubgraphSingleSourceShortestPathOutputFormatSir -op /out -ca giraph.subgraphVertexValueClass=org.apache.hadoop.io.DoubleWritable,subgraphSourceVertex=1,giraph.subgraphMessageValueClass=org.apache.hadoop.io.BytesWritable,giraph.outgoingMessageValueFactoryClass=in.dream_lab.goffish.giraph.factories.DefaultSubgraphMessageFactory,giraph.messageEncodeAndStoreType=POINTER_LIST_PER_VERTEX,giraph.clientSendBufferSize=20000000,giraph.clientReceiveBufferSize=20000000,giraph.graphPartitionerFactoryClass=in.dream_lab.goffish.giraph.factories.SubgraphPartitionerFactory,giraph.subgraphValueClass=org.apache.hadoop.io.LongWritable,giraph.vertexClass=in.dream_lab.goffish.giraph.graph.DefaultSubgraph,subgraphComputationClass=in.dream_lab.goffish.giraph.examples.SingleSourceShortestPath,giraph.edgeValueClass=org.apache.hadoop.io.DoubleWritable,giraph.vertexIdClass=in.dream_lab.goffish.giraph.graph.SubgraphId,giraph.vertexValueClass=in.dream_lab.goffish.giraph.graph.SubgraphVertices,giraph.outgoingMessageValueClass=in.dream_lab.goffish.giraph.graph.SubgraphMessage -yj goffish-giraph-1.2.0-for-hadoop-2.5.1-jar-with-dependencies.jar -mc in.dream_lab.goffish.giraph.master.SubgraphMasterCompute -w 1 -ca giraph.SplitMasterWorker=false







