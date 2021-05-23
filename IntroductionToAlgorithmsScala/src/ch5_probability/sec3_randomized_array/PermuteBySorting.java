package ch5_probability.sec3_randomized_array;

import java.util.*;

/**
 * Created by dleung on 9/30/15.
 */
public class PermuteBySorting {
    public static void main(String[] args) {
        List<Integer> input = new ArrayList(Arrays.asList(1, 2, 3, 4, 5));

        System.out.println(randomizeArray(input));
    }

    public static List<Integer> randomizeArray(List<Integer> input) {
        Random generator = new Random();
        Map<Double, Integer> map = new TreeMap();

        for (int i : input) {
            map.put(generator.nextDouble(), i);
        }

        return new ArrayList(map.values());

    }
}
