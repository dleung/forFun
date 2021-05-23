package ch2_sort.sec1_insertion_sort;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

// Insert sort desc

public class Question2InsertionSortDesc {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(1, 5, 2, 6, 3));

        for(int i = 0; i < list.size(); i++) {
            int ele = list.remove(i);

            loop:
            for(int j = i; j >= 0; j--) {
                if(j == 0 || ele < list.get(j - 1)) {
                    list.add(j, ele);
                    break loop;
                }
            }
        }

        System.out.println(list);
    }
}
