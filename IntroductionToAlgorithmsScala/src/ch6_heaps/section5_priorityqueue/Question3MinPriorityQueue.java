package ch6_heaps.section5_priorityqueue;


import ch6_heaps.sec2_heapsort;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class MinPriorityQueue {
    List<JobItem> jobItems = new ArrayList();

    public JobItem heapMinimum() {
        return jobItems.get(0);
    }

    // Decreases the priority (key) of the element at index to newKey
    public void heapDecreaseKey(int index, int newKey) {
        JobItem item = jobItems.get(index);
        if (item.key < newKey) {
            System.out.println("Error, new key is greater than old key");
        }

        item.key = newKey;

        while (index > 0 && jobItems.get(parentIndex(index)).key > newKey) {
            Collections.swap(jobItems, parentIndex(index), index);
            index = parentIndex(index);
        }
    }

    public JobItem heapExtractMin() {
        if (jobItems.size() == 0) {
            return null;
        }
        Collections.swap(jobItems, 0, jobItems.size() - 1);
        JobItem item = jobItems.remove(jobItems.size() - 1);

        minHeapify(0);

        return item;
    }

    // Places an element in an array into the correct final position in the heap
    public void minHeapify(int index) {
        int maxHeapIndex = jobItems.size() - 1;
        Integer lIndex = sec2_heapsort.leftIndex(index, maxHeapIndex);
        Integer rIndex = sec2_heapsort.rightIndex(index, maxHeapIndex);

        Integer smallestIndex = index;
        if (lIndex != null && jobItems.get(lIndex).key < jobItems.get(index).key) {
            smallestIndex = lIndex;
        }

        if (rIndex != null && jobItems.get(rIndex).key < jobItems.get(smallestIndex).key) {
            smallestIndex = rIndex;
        }

        if (smallestIndex != index) {
            Collections.swap(jobItems, smallestIndex, index);
            minHeapify(smallestIndex);
        }
    }

    public int parentIndex(int index) {
        if (index % 2 != 0) {
            return (index - 1) / 2;
        } else {
            return (index - 2) / 2;
        }
    }

    public void insert(int key, int value) {
        jobItems.add(new JobItem(Integer.MAX_VALUE, value));
        heapDecreaseKey(jobItems.size() - 1, key);
    }
}


public class Question3MinPriorityQueue {
    public static void main(String[] args) {
        MinPriorityQueue queue = new MinPriorityQueue();
        queue.insert(14, 1);
        queue.insert(10, 2);
        queue.insert(8, 3);
        queue.insert(5, 4);
        queue.insert(3, 5);
        queue.insert(1, 6);
        queue.insert(9, 7);
        queue.insert(16, 8);

        System.out.println(queue.jobItems);

        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
        System.out.println(queue.heapExtractMin());
    }
}
