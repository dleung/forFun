package ch6_heaps.section5_priorityqueue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by dleung on 10/13/15.
 */
class MultiArrayMerge {
    public static List<Integer> merge(List<Integer>... lists) {
        MinPriorityQueue minPriorityQueue = new MinPriorityQueue();
        for (List<Integer> list : lists) {
            for (Integer i : list) {
                minPriorityQueue.insert(i, 0);
            }
        }

        List<Integer> results = new ArrayList<>();

        JobItem item = minPriorityQueue.heapExtractMin();

        while (item != null) {
            results.add(item.key);
            item = minPriorityQueue.heapExtractMin();
        }

        return results;
    }
}

public class Question9MultiArrayMerge {
    public static void main(String[] args) {
        List<Integer> list1 = new ArrayList(Arrays.asList(1, 5, 6, 9));
        List<Integer> list2 = new ArrayList(Arrays.asList(3, 4, 11, 12));
        List<Integer> list3 = new ArrayList(Arrays.asList(2, 3, 10, 100));

        System.out.println(MultiArrayMerge.merge(list1, list2, list3));
    }
}
