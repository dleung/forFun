package ch5_probability.sec3_randomized_array;

import java.util.*;

/**
 * Created by dleung on 9/30/15.
 */
public class RandomizeInPlace {
    public static void main(String[] args) {
        List<Integer> input = new ArrayList(Arrays.asList(1, 2, 3, 4, 5));

        randomInPlace(input);

        System.out.println(input);
    }

    public static void randomInPlace(List<Integer> input) {
        Random generator = new Random();

        for (int i = 0; i < input.size(); i++) {
            Collections.swap(input, i, i + generator.nextInt(input.size() - i));
        }
    }
}
