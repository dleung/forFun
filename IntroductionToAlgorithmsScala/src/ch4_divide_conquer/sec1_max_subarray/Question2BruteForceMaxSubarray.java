package ch4_divide_conquer.sec1_max_subarray;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * O(n^2)
 */
public class Question2BruteForceMaxSubarray {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(100, 113, 110, 85, 105, 102, 86, 63, 81, 101, 94, 106, 101, 79, 94, 90, 97));

        System.out.println(maxSubarrayBruteForce(list));
    }

    /**
     * Similar to insertion sort, perform nested iteration to evaluate the sum between all pairs
     */
    public static Subarray maxSubarrayBruteForce(List<Integer> list) {
        int maxSum = Integer.MIN_VALUE;
        int left = 0;
        int right = 0;

        for (int i = 0; i < list.size(); i++) {
            for (int j = i + 1; j < list.size(); j++) {

                int sum = 0;
                for (int k = i; k < j; k++) {
                    sum += list.get(k + 1) - list.get(k);
                }

                if (sum > maxSum) {
                    maxSum = sum;
                    left = i;
                    right = j;
                }
            }
        }

        return new Subarray(left, right, maxSum);
    }
}
