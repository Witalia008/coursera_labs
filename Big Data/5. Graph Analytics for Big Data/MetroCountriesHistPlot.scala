import breeze.linalg._
import breeze.plot._

def degreeHistogram(net: Graph[PlaceNode, Int]): Array[(Int, Int)] =
  net.degrees.
    filter { case (vid, count) => vid >= 100 }.
    map(t => (t._2,t._1)).
    groupByKey.map(t => (t._1,t._2.size)).
    sortBy(_._1).collect()

val nn = metrosGraph.vertices.filter{ case (vid, count) => vid >= 100 }.count()

val metroDegreeDistribution = degreeHistogram(metrosGraph).map({case(d,n) => (d,n.toDouble/nn)})

val f = Figure()
val p1 = f.subplot(2,1,0)
val x = new DenseVector(metroDegreeDistribution map (_._1.toDouble))
val y = new DenseVector(metroDegreeDistribution map (_._2))

p1.xlabel = "Degrees"
p1.ylabel = "Distribution"
p1 += plot(x, y)
p1.title = "Degree distribution"


val p2 = f.subplot(2,1,1)
val metrosDegrees = metrosGraph.degrees.filter { case (vid, count) => vid >= 100 }.map(_._2).collect()

p2.xlabel = "Degrees"
p2.ylabel = "Histogram of node degrees"
p2 += hist(metrosDegrees, 20)
