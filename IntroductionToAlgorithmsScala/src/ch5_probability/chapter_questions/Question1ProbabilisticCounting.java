package ch5_probability.chapter_questions;


import java.util.Random;

public class Question1ProbabilisticCounting {
    interface Operation {
        int operation(int b);
    }
    public static void main(String[] args) {
        Random generator = new Random();
        Operation twoPowFunc = (int x) ->  (int) Math.pow(2.0, (double) x);
        Operation linearFunc = (int x) -> x;
        Operation doubleFunc = (int x) -> 2 * x;

        int counter = 0;

        for (int i = 0; i < 100; i++) {
            double probability = probOfIncrement(counter, doubleFunc);
            System.out.println("Probability: " + probability);
            double randomNum = generator.nextDouble();
            System.out.println("Chosen: " + randomNum);
            if (randomNum <= probability) {
                counter++;
            }

            System.out.println(counter);
        }
    }

    public static double probOfIncrement(int i, Operation func) {
        return 1.0/(func.operation(i+1) - func.operation(i));
    }
}
