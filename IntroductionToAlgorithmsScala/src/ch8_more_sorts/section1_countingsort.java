package ch8_more_sorts;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class section1_countingsort {
  // This O(n) sort 'counts' the occurrence of each element and then builds
  // a result array based on the number of occurrence. Only works for positive integers
  public static void main(String[] args) {
    List<Integer> array = Arrays.asList(1, 2, 5, 1, 9, 3, 4);

    System.out.println(countingSort(array));
  }

  public static List<Integer> countingSort(List<Integer> array) {
    Integer max = Collections.max(array);

    // Initialize an array of zeros with size 'max'
    List<Integer> countingElement = new ArrayList<>(Collections.nCopies(max + 1, 0));

    for (Integer e : array) {
      countingElement.set(e, countingElement.get(e) + 1);
    }

    List<Integer> results = new ArrayList<>();
    for (Integer value = 0; value < countingElement.size(); value++) {
      for (Integer i = 0; i < countingElement.get(value); i++) {
        results.add(value);
      }
    }

    return results;
  }
}
