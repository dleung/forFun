package ch2_sort.chapter_questions;

import java.util.*;

import ch2_sort.sec1_insertion_sort.Question1InsertionSort;

// Modified merge sort that splits the array into k sublists and checks to see if each sublist
// is smaller than k.  If it is, perform insertion sort.  Else, perform the recursive call
// on each sublist.  After sort, merge all the sublists together.
// Compared to merge sort, this has a more effient worst case running time of O(kn + nlog(n/k))

public class Question1InsertionSortOnMergeSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>(Arrays.asList(1, 5, 3, 9, 10, 0, -10, 100, 2, 3));
        int k = 3; // In practice, this should be the size at which insertion sort outperforms merge sort, performed empirically

        System.out.println(modifiedMergeSort(list, k));
    }

    public static List<Integer> modifiedMergeSort(List<Integer> list, int k) {
        if(list.size() <= k) {
            Question1InsertionSort.insertionSort(list);
            return list;
        } else {
            List<List<Integer>> sublists = splitListIntoSublists(list, k);

            for (List<Integer> sublist: sublists) {
                modifiedMergeSort(sublist, k);
            }

            return mergeLists(sublists);
        }
    }

    public static List<List<Integer>> splitListIntoSublists(List<Integer> list, int k) {
        int sublistSize = (int) Math.round((double)(list.size()) / (double)(k));

        List<List<Integer>> result = new ArrayList<List<Integer>>();

        int start = 0;
        int end = sublistSize;

        while (end < list.size()) {
            result.add(list.subList(start, end));

            start += sublistSize;
            end += sublistSize;

            if (end > list.size() - 1) {
                result.add(list.subList(start, list.size()));
            }
        }

        return result;
    }

    public static List<Integer> mergeLists(List<List<Integer>> sublists) {
        // Mapping of sublist index and pointer index
        List<Integer> pointers = new ArrayList<Integer>();

        // Mapping of sublist index and pointer value
        List<Integer> pointerValues = new ArrayList<Integer>();

        int totalSize = 0;

        // Initialize sublist pointers
        for (int i = 0; i < sublists.size(); i++) {
            List<Integer> sublist = sublists.get(i);
            pointers.add(i, 0);
            totalSize += sublist.size();
            pointerValues.add(i, sublist.get(0));
        }

        int resultPointer = 0;

        List<Integer> result = new ArrayList<Integer>(totalSize);
        while (resultPointer < totalSize - 1) {
            Integer smallestValue = Integer.MAX_VALUE;
            Integer smallestSublistIndex = 0;

            for (int i = 0; i < pointerValues.size(); i ++) {
                Integer ele = pointerValues.get(i);
                if (ele != null && ele < smallestValue) {
                    smallestValue = ele;
                    smallestSublistIndex = i;
                }
            }

            // Add the smallest value to the result
            result.add(smallestValue);

            // Update both pointer index and pointer values
            int smallestSublistPointer = pointers.get(smallestSublistIndex);
            int nextPointer = smallestSublistPointer + 1;

            if (nextPointer >= sublists.get(smallestSublistIndex).size()) {
                pointerValues.set(smallestSublistIndex, null);
            } else {
                Integer nextPointerValue = sublists.get(smallestSublistIndex).get(nextPointer);
                pointerValues.set(smallestSublistIndex, nextPointerValue);
                pointers.set(smallestSublistIndex, nextPointer);
            }

            resultPointer ++;
        }

        return result;
    }
}
