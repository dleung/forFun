package ch2_sort.chapter_questions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Question2BubbleSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(1, 5, 2, 6, 1));
        bubbleSort(list);
    }

    public static void bubbleSort(List<Integer> list) {
        for (int i = 0; i < list.size() - 1; i++) {
            for (int j = list.size() - 1; j > 0; j--) {
                if (list.get(j) < list.get(j - 1)) {
                    Collections.swap(list, j - 1, j);
                }
            }
        }
    }
}
