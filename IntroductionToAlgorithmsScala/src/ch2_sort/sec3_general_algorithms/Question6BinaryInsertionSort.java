package ch2_sort.sec3_general_algorithms;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Question6BinaryInsertionSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(1, 5, 3, 4, 10, -19));

        binaryInsertionSort(list, list.size() - 1);

        System.out.println(list);
    }

    public static void binaryInsertionSort(List<Integer> list, Integer position) {
        if(position == 0) {
            return;
        } else if (position == 1) {
            if (list.get(0) > list.get(1)) {
                Collections.swap(list, 0, 1);
            }
        } else {
            binaryInsertionSort(list, position - 1);

            Integer positionVal = binarySearch(list, 0, position-1, list.get(position));
            Integer e = list.remove(position.intValue());
            list.add(positionVal, e);
        }
    }

    public static Integer binarySearch(List<Integer> list, Integer start, Integer end, Integer value) {
        if (list.get(start) >= value && list.get(end) < value) {
            return start;
        } else if (end - start == 0) {
            return null;
        } else if (list.get(start) > value) {
            return 0;
        } else if (list.get(end) < value) {
            return end + 1;
        }

        Integer midpoint = start + (end - start) / 2;

        Integer leftValue = binarySearch(list, start, midpoint, value);
        if (leftValue != null) {
            return leftValue;
        }
        Integer rightValue = binarySearch(list, midpoint + 1, end, value);
        if (rightValue != null) {
            return rightValue;
        }

        if (value < list.get(midpoint + 1) && value >= list.get(midpoint)) {
            return midpoint + 1;
        }

        return 0;
    }
}
