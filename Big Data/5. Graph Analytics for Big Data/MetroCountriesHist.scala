metrosGraph.numEdges
metrosGraph.numVertices

def max(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 > b._2) a else b
}

def min(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 <= b._2) a else b
}

val maxOutDeg = metrosGraph.outDegrees.reduce(max)
maxOutDeg

metrosGraph.vertices.filter(_._1 == maxOutDeg._1).collect()

val maxInDeg = metrosGraph.inDegrees.reduce(min)
maxInDeg

metrosGraph.vertices.filter(_._1 == maxInDeg._1).collect()

metrosGraph.outDegrees.filter(_._2 <= 1).count

metrosGraph.degrees.reduce(max)

metrosGraph.degrees.reduce(min)

metrosGraph.degrees.
  filter { case (vid, count) => vid >= 100}.  // only countries
  map(t => (t._2, t._1)).
  groupByKey.map(t => (t._1, t._2.size)).
  sortBy(_._1).collect()

