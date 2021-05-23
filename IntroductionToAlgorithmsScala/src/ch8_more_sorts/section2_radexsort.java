package ch8_more_sorts;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * O(n) sorting where you sort by radex position first
 */
public class section2_radexsort {
  public static void main(String[] args) {
    List<Integer> array = Arrays.asList(1, 443, 718172, 22, 10, 22, 1000, 999);
    System.out.println(countingSort(array));
  }

  public static List<Integer> countingSort(List<Integer> array) {
    Integer maxValue = new Integer(Collections.max(array));
    Integer radexes = 1;
    while (maxValue != 0) {
      maxValue /= 10;
      radexes++;
    }

    for (int i = 1; i <= radexes; i++) {
      array = sortByRadex(array, i);
    }
    return array;
  }

  public static List<Integer> sortByRadex(List<Integer> array, Integer radex) {
    List<List<Integer>> countedElements = new ArrayList<>();
    for (int i = 0; i <= 9; i++) {
      countedElements.add(new ArrayList<>());
    }

    Integer tens = ((Double) Math.pow(10.0, radex.doubleValue())).intValue();

    List<Integer> radexElements = array.stream().
        map(e -> ((e % tens) / (tens/ 10))).
            collect(Collectors.toList());

    for (int index = 0; index < radexElements.size(); index ++) {
      Integer position = radexElements.get(index);
      List<Integer> elementsPerRadex = countedElements.get(position);
      elementsPerRadex.add(array.get(index));
      countedElements.set(position, elementsPerRadex);
    }

    List<Integer> results = new ArrayList<>();
    for (List<Integer> elements : countedElements) {
      for (Integer element : elements) {
        results.add(element);
      }
    }

    return results;
  }
}
