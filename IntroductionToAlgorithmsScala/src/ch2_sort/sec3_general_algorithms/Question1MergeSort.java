package ch2_sort.sec3_general_algorithms;

// Merge Sort

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Question1MergeSort {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(2, 19, 0, -10, 10, 2, 1));

        mergeSort(list, 0, list.size() - 1);

        System.out.println(list);
    }

    public static void mergeSort(List<Integer> list, int a, int b) {
        if (b - a > 0) {
            int midpoint = (b + a) / 2;
            mergeSort(list, a, midpoint);
            mergeSort(list, midpoint + 1, b);

            merge(list, a, midpoint + 1, b);
            System.out.println("Result of merge: " + list);
        }
    }

    public static void merge(List<Integer> list, Integer start, Integer midpoint, Integer end) {
        int resultPointer = start;
        int aListPointer = 0;
        int bListPointer = 0;

        List<Integer> newList = new ArrayList<Integer>(list);

        List<Integer> aList = newList.subList(start, midpoint);
        List<Integer> bList = newList.subList(midpoint, end + 1);

        Integer aEle = list.get(start);
        Integer bEle = list.get(midpoint);

        while (resultPointer <= end) {
            if (bEle == null || (aEle != null && aEle < bEle)) {
                list.set(resultPointer, aEle);
                aListPointer++;

                if (aListPointer >= aList.size()) {
                    mergeArray(bList, bListPointer, list, resultPointer + 1);
                    resultPointer = end;
                } else {
                    aEle = aList.get(aListPointer);
                }
            } else {
                list.set(resultPointer, bEle);
                bListPointer++;

                if (bListPointer >= bList.size()) {
                    mergeArray(aList, aListPointer, list, resultPointer + 1);
                    resultPointer = end;
                } else {
                    bEle = bList.get(bListPointer);
                }
            }

            resultPointer ++;
        }
    }

    public static void mergeArray(List<Integer> orig, Integer origPointer, List<Integer> finalList, Integer start) {
        for(int i = origPointer; i < orig.size(); i++) {
            finalList.set(start, orig.get(i));
            start++;
        }
    }
}
