package ch10_elementary_data_structures

import scala.reflect.ClassTag

trait Queue[T] {
  def enqueue(ele: T): Unit
  def dequeue(): T
  def head: T
  def tail: T
}

object Section1Queue {
  def main(arg: Array[String]) = {
    val queue = new Section1Queue[Integer](3)
    queue.enqueue(1)
    queue.enqueue(2)
    assert(queue.dequeue() == 1)
    queue.enqueue(3)
    assert(queue.dequeue() == 2)
    assert(queue.dequeue() == 3)
    queue.enqueue(4)
    queue.enqueue(5)
    assert(queue.dequeue() == 4)
    assert(queue.dequeue() == 5)
  }
}

/**
  * Head < tail in a queue.  FIFO
  */
class Section1Queue[T](capacity: Int)(implicit m: ClassTag[T]) extends Queue[T] {
  val queue = Array.fill[Option[T]](capacity) { None }.toBuffer

  var headIndex = 0
  var tailIndex = 0

  def head: T = queue(headIndex).get

  def tail: T = queue(tailIndex).get

  def enqueue(ele: T) = {
    queue(tailIndex) match {
      case Some(x) => throw new Exception("Queue overflow")
      case None =>
        queue(tailIndex) = Some(ele)

        if (tailIndex + 1 >= capacity) {
          tailIndex = 0
        } else {
          tailIndex += 1
        }
    }
  }

  def dequeue(): T = {
    queue(headIndex) match {
      case None => throw new Exception("Queue underflow")
      case Some(ele) =>
        val ele = queue(headIndex).get
        queue(headIndex) = None

        if (headIndex + 1 == capacity) {
          headIndex = 0
        } else {
          headIndex += 1
        }

        ele
    }
  }
}
