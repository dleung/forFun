package ch5_probability.sec1_randomization;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class Question3BiasedRandomGenerator {
    // Generate a number of 0 or 1
    static Random generator = new Random();

    public static void main(String[] args) {
        double probability = generator.nextDouble();
        System.out.println("Biased random generator at p = " + probability);
        Map count = new HashMap<Integer, Integer>();

        for (int i = 0; i < 10000; i ++) {
            int randomInt = random(probability);

            if (count.containsKey(randomInt)) {
                count.put(randomInt, ((Integer)count.get(randomInt) + 1));
            } else {
                count.put(randomInt, 1);
            }
        }

        System.out.println(count);
    }

    public static int random(double probability) {
        boolean found = false;

        int firstToss = biasedRandom(probability);
        int secondToss = biasedRandom(probability);

        if (firstToss == 1 && secondToss == 0) {
            return 1;
        } else if (firstToss == 0 && secondToss == 1) {
            return 0;
        }

        return random(probability);
    }

    // (0, 1) * 2 + (0..1) = (0,1,2,3)   // Range of 0..3
    // (0, 1, 2) * 3 + (0..2) = (0,1,2,3,4,5,6,7,8) // Range of 0..8
    public static int biasedRandom(double probability) {
        if (generator.nextDouble() > probability) {
            return 1;
        } else {
            return 0;
        }
    }
}

