package ch2_sort.chapter_questions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Question4Inversion {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(2, 3, 8, 6, 1));

        System.out.println(getInversions(list, 0));
    }

    public static List<List<Integer>> getInversions(List<Integer> list, int pointer) {
        List<List<Integer>> results = new ArrayList<List<Integer>>();

        if (pointer == list.size() - 1) {
            return results;
        }

        for (int i = pointer + 1; i < list.size(); i++) {
            if (list.get(pointer) > list.get(i)) {
                results.add(new ArrayList(Arrays.asList(list.get(pointer), list.get(i))));
            }
        }

        results.addAll(getInversions(list, pointer + 1));

        return results;
    }
}
