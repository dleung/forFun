package ch4_divide_conquer.sec1_max_subarray;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by dleung on 9/23/15.
 */
public class Question5LinearMaxSubarray {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList(Arrays.asList(100, 113, 110, 85, 105, 102, 86, 63, 81, 101, 94, 106, 101, 79, 94, 90, 97));

        System.out.println(maxSubarrayLinear(list));
    }

    /**
     * Similar to insertion sort, perform nested iteration to evaluate the sum between all pairs
     */
    public static Subarray maxSubarrayLinear(List<Integer> list) {
        Subarray result = new Subarray(0, 0, 0);

        int currSum = 0;
        int currLeft = 0;


        for (int i = 0; i < list.size() - 1; i++) {
            currSum += list.get(i + 1) - list.get(i);

            if (currSum < 0) {
                currSum = 0;
                currLeft = i + 1;
            }

            if (currSum > result.sum) {
                result.sum = currSum;
                result.end = i + 1;
                result.start = currLeft;
            }
        }

        return result;
    }
}
