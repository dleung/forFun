package ch4_divide_conquer.sec1_max_subarray;

public class Subarray {
    int start;
    int end;
    int sum;

    public Subarray(int start, int end, int sum) {
        this.start = start;
        this.end = end;
        this.sum = sum;
    }

    @Override public String toString() {
        return "start: " + start + ", end: " + end + ", sum: " + sum;
    }
}