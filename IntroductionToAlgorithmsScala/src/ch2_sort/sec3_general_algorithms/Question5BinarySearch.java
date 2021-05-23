package ch2_sort.sec3_general_algorithms;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Question5BinarySearch {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(1, 2, 3, 10, 11, 20));

        System.out.println(binarySearch(list, 0, list.size() - 1, 11));
    }

    public static Integer binarySearch(List<Integer> list, Integer start, Integer end, Integer value) {
        if (list.get(start) == value) {
            return start;
        } else if (end - start == 0) {
            return null;
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

        return null;
    }
}
