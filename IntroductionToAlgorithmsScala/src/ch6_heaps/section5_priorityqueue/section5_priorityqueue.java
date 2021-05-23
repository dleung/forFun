package ch6_heaps.section5_priorityqueue;

import ch6_heaps.sec2_heapsort;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class PriorityQueue {
    List<JobItem> jobItems = new ArrayList();

    // Increases the priority (key) of the element at index to newKey
    public void heapIncreaseKey(int index, int newKey) {
        JobItem item = jobItems.get(index);
        if (item.key > newKey) {
            System.out.println("Error, new key is less than old key");
        }

        item.key = newKey;

        while (index > 0 && jobItems.get(parentIndex(index)).key < newKey) {
            Collections.swap(jobItems, parentIndex(index), index);
            index = parentIndex(index);
        }
    }

    public void insert(int key, int value) {
        jobItems.add(new JobItem(Integer.MIN_VALUE, value));

        heapIncreaseKey(jobItems.size() - 1, key);
    }

    public JobItem heapExtractMax() {
        if (jobItems.size() < 1) {
            return null;
        }

        JobItem max = jobItems.get(0);
        Collections.swap(jobItems, 0, jobItems.size() - 1);
        jobItems.remove(jobItems.size() - 1);
        maxHeapify(0);

        return max;
    }

    public void heapDelete(int index) {
        int maxHeapIndex = jobItems.size() - 1;
        Integer lIndex = sec2_heapsort.leftIndex(index, maxHeapIndex);
        Integer rIndex = sec2_heapsort.rightIndex(index, maxHeapIndex);

        Integer largestIndex = index;
        if (lIndex != null && jobItems.get(lIndex).key > jobItems.get(index).key) {
            largestIndex = lIndex;
        }

        if (rIndex != null && jobItems.get(rIndex).key > jobItems.get(largestIndex).key) {
            largestIndex = rIndex;
        }

        if (largestIndex != index) {
            Collections.swap(jobItems, largestIndex, index);
            heapDelete(largestIndex);
        } else {
            jobItems.remove(index);
        }
    }

    public int parentIndex(int index) {
        if (index % 2 != 0) {
            return (index - 1) / 2;
        } else {
            return (index - 2) / 2;
        }
    }

    // Places an element in an array into the correct final position in the heap
    public void maxHeapify(int index) {
        int maxHeapIndex = jobItems.size() - 1;
        Integer lIndex = sec2_heapsort.leftIndex(index, maxHeapIndex);
        Integer rIndex = sec2_heapsort.rightIndex(index, maxHeapIndex);

        Integer largestIndex = index;
        if (lIndex != null && jobItems.get(lIndex).key > jobItems.get(index).key) {
            largestIndex = lIndex;
        }

        if (rIndex != null && jobItems.get(rIndex).key > jobItems.get(largestIndex).key) {
            largestIndex = rIndex;
        }

        if (largestIndex != index) {
            Collections.swap(jobItems, largestIndex, index);
            maxHeapify(largestIndex);
        }
    }
}

public class section5_priorityqueue {
    public static void main(String[] args) {
        PriorityQueue queue = new PriorityQueue();
        queue.insert(14, 1);
        queue.insert(10, 2);
        queue.insert(8, 3);
        queue.insert(5, 4);
        queue.insert(3, 5);
        queue.insert(1, 6);
        queue.insert(9, 7);
        queue.insert(16, 8);

        System.out.println(queue.jobItems);
        queue.heapDelete(3);

        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
        System.out.println(queue.heapExtractMax());
    }
}
