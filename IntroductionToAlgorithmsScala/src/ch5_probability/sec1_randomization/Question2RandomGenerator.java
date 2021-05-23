package ch5_probability.sec1_randomization;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * Write a random number generator given random(0,1)
 */
public class Question2RandomGenerator {
    public static void main(String[] args) {
        Map count = new HashMap<Integer, Integer>();

        for (int i = 0; i < 10000; i ++) {
            int randomInt = random(6,100);

            if (count.containsKey(randomInt)) {
                count.put(randomInt, ((Integer)count.get(randomInt) + 1));
            } else {
                count.put(randomInt, 1);
            }
        }

        System.out.println(count);
    }

    public static int random(int a, int b) {
        int range = b - a;

        int randomInt;

        if (range == 1) {
            return random() + a;
        } else if (range < 4) {
            randomInt = random() * 2 + random();
        } else {
            int power = (int) Math.ceil(Math.sqrt((double)range));
            randomInt = random(0, power) * (1 + power) + random(0, power);
        }

        if (randomInt > range) {
            return random(a,b);
        } else {
            return randomInt + a;
        }
    }

    // (0, 1) * 2 + (0..1) = (0,1,2,3)   // Range of 0..3
    // (0, 1, 2) * 3 + (0..2) = (0,1,2,3,4,5,6,7,8) // Range of 0..8

    // Generate a number of 0 or 1
    static Random generator = new Random();
    public static int random() {
        return generator.nextInt(2);
    }
}
