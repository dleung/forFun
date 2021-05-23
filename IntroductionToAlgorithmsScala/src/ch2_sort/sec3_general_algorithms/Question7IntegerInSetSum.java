package ch2_sort.sec3_general_algorithms;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by dleung on 9/22/15.
 */
public class Question7IntegerInSetSum {
    public static void main(String[] args) {
        Set<Integer> set = new HashSet<Integer>(Arrays.asList(1, 2));
        System.out.println(twoSumExistsInSet(4, set));
    }

    public static boolean twoSumExistsInSet(Integer sum, Set<Integer> set) {
        for (Integer ele : set) {
            if(set.contains(sum - ele)) {
                return true;
            }
        }

        return false;
    }
}
