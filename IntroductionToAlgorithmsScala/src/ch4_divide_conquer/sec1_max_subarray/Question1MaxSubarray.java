package ch4_divide_conquer.sec1_max_subarray;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Divide and conquer strategy to determine max subarray, similar to mergeSort. O(nlgn)
 */
public class Question1MaxSubarray {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(100, 113, 110, 85, 105, 102, 86, 63, 81, 101, 94, 106, 101, 79, 94, 90, 97));

        System.out.println(maxSubarray(list, 0, list.size() - 1));
    }

    // O(lg(n))
    public static Subarray maxSubarray(List<Integer> list, int left, int right) {
        if (right == left) {
            return new Subarray(left, right, 0);
        }

        int mid = left + ((right - left) / 2); // 0
        Subarray leftSubarray = maxSubarray(list, left, mid);
        Subarray rightSubarray = maxSubarray(list, mid + 1, right);
        Subarray midSubarray = maxCrossArrays(list, left, mid + 1, right);

        if (leftSubarray.sum > rightSubarray.sum && leftSubarray.sum > midSubarray.sum) {
            return leftSubarray;
        } else if (rightSubarray.sum > leftSubarray.sum && rightSubarray.sum > midSubarray.sum) {
            return rightSubarray;
        } else {
            return midSubarray;
        }
    }

    // O(n)
    public static Subarray maxCrossArrays(List<Integer> list, int left, int mid, int right) {
        int minLeftIndex = left;
        int minLeftValue = Integer.MAX_VALUE;
        for (int i = left; i < mid; i++) {
            if (list.get(i) < minLeftValue) {
                minLeftIndex = i;
                minLeftValue = list.get(i);
            }
        }

        int maxRightIndex = mid;
        int maxRightValue = Integer.MIN_VALUE;
        for (int i = mid; i <= right; i++) {
            if (list.get(i) > maxRightValue) {
                maxRightIndex = i;
                maxRightValue = list.get(i);
            }
        }

        return new Subarray(minLeftIndex, maxRightIndex, maxRightValue - minLeftValue);
    }
}
