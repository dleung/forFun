package ch9_selection

import scala.collection.mutable
import scala.util.Random

/**
  * Find the ith smallest element in an array
  */
object Section3SelectionWorstCaseLinearTime {
  val Partitions = 5 // Not sure why this is the case

  def main(arg: Array[String]) = {
    assert(select(Vector(3, 7).toBuffer, 1) == 3)
    assert(select(Vector(1,3,2,4).toBuffer, 2) == 2)
    assert(select(Vector(11, 3, 8).toBuffer, 2) == 8)
    assert(select(Vector(12,11,6,7,1,2,3,5,4,8).toBuffer, 2) == 2)
  }

  /**
    * @param arr the input array
    * @param i ith smallest element of the array to find
    * @return the ith smallest integer, and the index of it
    */
  def select(arr: mutable.Buffer[Int], i: Int): Int = {
    require (i > 0)
    if (i == 0 || arr.size == 1) {
      return arr.head
    }

    val partitions = arr.size / Partitions

    // Create a medians of medians array
    val medianArray = arr.grouped(Partitions).map { partArray =>
      val sortedArray = insertionSort(partArray)
      sortedArray(findMedianIndex(sortedArray))
    }.toBuffer

    // Get the median of the medianArray
    val medianOfMedians = select(medianArray, findMedianIndex(medianArray))

    // partition the original array based on the median of medianArray
    partition(arr, 0, arr.indexOf(medianOfMedians))
    val newMedianIndex = arr.indexOf(medianOfMedians)

    val k = newMedianIndex + 1 // 1 more than the number of elements on the low side
    if (i == k) {
      medianOfMedians
    } else if (i < k) {
      select(arr.slice(0, k), i)
    } else {
      select(arr.slice(k, arr.size), i - k)
    }
  }

  // array needs to be sorted
  def findMedianIndex(array: mutable.Buffer[Int]): Int = {
    if (array.size == 1) {
      1
    } else {
      if (array.size % 2 == 0) {
        array.size / 2
      } else {
        array.size / 2 + 1
      }
    }
  }

  def insertionSort(array: mutable.Buffer[Int]) = {
    (1 until array.size).foreach { index =>
      var j = index
      while (j != 0 && array(index) <= array(j - 1)) {
        swap(array, j, j-1)
        j -= 1
      }
    }

    array
  }

  /**
    * Partitions the array from q to p using a random index
    *
    * @return the index of the partition.  Everything on the left side
    *         of the index is smaller than the index value, and everything on the right
    *         side is larger
    */
  def randomPartition(array: mutable.Buffer[Int], p: Int, q: Int): Int = {
    val randomPivot = Random.nextInt(q - p) + p
    swap(array, randomPivot, q)

    //partition(array, p, q, randomPivot)
    randomPivot
  }

  /**
    * @return Everything on the left side
    *         of the pivotIndex is smaller than the index value, and everything on the right
    *         side is larger
    */
  def partition(array: mutable.Buffer[Int], startIndex: Int, pivotIndex: Int): Unit = {
    require(pivotIndex < array.size, throw new Exception("End index must be smaller than element length - 1"))
    require (startIndex >= 0, throw new Exception("Start index must be greater than or equal to 0"))

    val pivot = array(pivotIndex)
    var insertionIndex = startIndex - 1

    (startIndex until pivotIndex).zipWithIndex.foreach { case(index, _) =>
      if(array(index) <= pivot) {
        insertionIndex += 1
        swap(array, insertionIndex, index)
      }
    }

    swap(array, pivotIndex, insertionIndex + 1)
  }

  def swap(array: mutable.Buffer[Int], p: Int, q: Int): Unit = {
    val temp = array(p)
    array(p) = array(q)
    array(q) = temp
  }
}