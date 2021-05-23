package ch7_quicksort.sec1_quicksort;

import com.sun.deploy.util.StringUtils;

import java.util.Arrays;
import java.util.Random;

public class section1_quicksort {
  static Random rand = new Random();

  public static void main(String[] args) {
    int[] array = {1, 5, 3, 7, 3, 1, 2, 10, 0, -10, 100, 40, 2, 101};

    quickSort(array, 0, array.length - 1);

    System.out.println(Arrays.toString(array));
  }

  /*
  * Worst case is n2, but average is n log n
   */
  public static void quickSort(int[] array, int p, int q) {
    int idx = partition(array, p, q);
    if (idx > p) quickSort(array, p, idx - 1);
    if (idx < q) quickSort(array, idx + 1, q);
  }

  /**
   * @param p start index to operate the range on
   * @param q end index
   * @return an index of the partition.  By default, we will use pivot to be array.size -1
   */
  public static int partition(int[] array, int p, int q) {
    if (p == q) return q;

    int randomPivot = rand.nextInt(q - p) + p;
    swap(array, randomPivot, q);

    int pivot = array[q];
    int pivotIndex = p;

    for (int i = p; i < q; i++) {
      if (array[i] < pivot) {
        swap(array, pivotIndex, i);
        pivotIndex ++;
      }
    }

    swap(array, pivotIndex, q);
    return pivotIndex;
  }

  public static void swap(int[] array, int p, int q) {
    int temp = array[p];
    array[p] = array[q];
    array[q] = temp;
  }
}

