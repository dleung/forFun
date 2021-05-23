package ch2_sort.sec3_general_algorithms;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Recursive insertion sort
 */

public class Question4RecursiveInsertionSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(1, 5, 3, 0));

        insertionSortRecursive(list, list.size() - 1);

        System.out.println(list);
    }

    public static void insertionSortRecursive(List<Integer> list, Integer position) {
        if(position == 0) {
            return;
        } else if (position == 1) {
            if (list.get(0) > list.get(1)) {
                Collections.swap(list, 0, 1);
            }
        } else {
            insertionSortRecursive(list, position - 1);

            while (position > 0 && list.get(position - 1) > list.get(position)) {
                Collections.swap(list, position, position - 1);
                position --;
            }
        }
    }
}
