package ch10_elementary_data_structures

import scala.reflect.ClassTag

object Section1Stack {
  def main(arg: Array[String]) = {
    val stack = new Section1Stack[Integer](3)
    stack.push(1)
    stack.push(2)
    stack.push(3)
    assert(stack.pop() == 3)
    assert(stack.pop() == 2)
    stack.push(4)
    assert(stack.pop() == 4)
    assert(stack.pop() == 1)
  }
}

trait Stack[T] {
  // Index of the top element
  def top: T
  def isEmpty: Boolean
  def push(ele: T): Unit
  def pop(): T
}

/**
  * LIFO
  */
class Section1Stack[T](len: Int)(implicit m: ClassTag[T]) extends Stack[T] {
  val stack = new Array[T](len).toBuffer
  var topIndex: Int = 0

  override def top: T = stack(topIndex)

  override def push(ele: T): Unit = {
    if (topIndex >= len) {
      throw new Exception("Stack overflow")
    }
    stack(topIndex) = ele
    topIndex += 1
  }

  override def pop(): T = {
    if (topIndex == 0) {
      throw new Exception("Stack underflow")
    }

    topIndex -= 1
    stack(topIndex)
  }

  override def isEmpty: Boolean = {
    topIndex == 0
  }
}