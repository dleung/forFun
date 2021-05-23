package ch2_sort.sec1_insertion_sort;

// Linear Search

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Question3LinearSearch {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(1, 2, 5, 3));

        System.out.println(linearSearch(list, 2));
        System.out.println(linearSearch(list, 4));
    }

    public static Integer linearSearch(List<Integer> list, Integer ele) {
        for (int i = 0; i < list.size(); i++) {
            if(list.get(i) == ele) {
                return i;
            }
        }

        return null;
    }
}
