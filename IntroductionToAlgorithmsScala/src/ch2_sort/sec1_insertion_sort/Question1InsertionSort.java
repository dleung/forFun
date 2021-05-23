package ch2_sort.sec1_insertion_sort;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

// Insert sort asc

public class Question1InsertionSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(100, 1, 50, 9, 30));

        insertionSort(list);

        System.out.println(list);
    }

    public static void insertionSort(List<Integer> list) {
        for(int i = 0; i <= list.size() - 1; i++) {
            int ele = list.get(i);

            int j = i;
            while (j != 0 && ele <= list.get(j - 1)) {
                Collections.swap(list, j, j-1);
                j--;
            }
        }
    }
}
