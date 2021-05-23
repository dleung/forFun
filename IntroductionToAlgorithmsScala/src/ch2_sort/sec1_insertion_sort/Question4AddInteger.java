package ch2_sort.sec1_insertion_sort;

/**
 * Add 2 integers
 */
public class Question4AddInteger {
    public static void main(String[] args) {
        int a = 1;
        int b = 10;

        int smaller;
        int greater;
        if(a < b) {
            smaller = a;
            greater = b;
        } else {
            smaller = b;
            greater = 1;
        }

        int sum = smaller;
        for(int i = 0; i < greater; i++) {
            sum++;
        }

        System.out.println(sum);
    }
}
