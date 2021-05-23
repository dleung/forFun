package ch6_heaps;

import java.util.*;

/**
 * Created by dleung on 9/30/15.
 */
public class sec2_heapsort {
    public static void main(String[] args) {
        List<Integer> array = new ArrayList(Arrays.asList(4,1,3,2,16,9,10,14,8,7));

        heapSort(array);

        System.out.println(array);
    }

    public static void heapSort(List<Integer> list) {
        buildMaxHeap(list);

        for (int i = list.size() - 1; i >= 1; i --) {
            Collections.swap(list, 0, i);

            maxHeapify(list, 0, i - 1);
        }
    }

    public static void buildMaxHeap(List<Integer> list) {
        for (int i = (list.size() / 2) - 1; i >= 0; i--) {
            maxHeapify(list, i, list.size() - 1);
        }
    }


    // Places an element in an array into the correct final position in the heap
    public static void maxHeapify(List<Integer> list, int index, int maxHeapIndex) {
        Integer lIndex = leftIndex(index, maxHeapIndex);
        Integer rIndex = rightIndex(index, maxHeapIndex);

        Integer largestIndex = index;
        if (lIndex != null && list.get(lIndex) > list.get(index)) {
            largestIndex = lIndex;
        }

        if (rIndex != null && list.get(rIndex) > list.get(largestIndex)) {
            largestIndex = rIndex;
        }

        if (largestIndex != index) {
            Collections.swap(list, largestIndex, index);
            maxHeapify(list, largestIndex, maxHeapIndex);
        }
    }

    public static Integer leftIndex(int index, int maxHeapIndex) {
        int newIndex = index * 2 + 1;
        if (newIndex > maxHeapIndex) {
            return null;
        }
        return newIndex;
    }

    public static Integer rightIndex(int index, int maxHeapIndex) {
        int newIndex = index * 2 + 2;
        if (newIndex > maxHeapIndex) {
            return null;
        }
        return newIndex;
    }
}
