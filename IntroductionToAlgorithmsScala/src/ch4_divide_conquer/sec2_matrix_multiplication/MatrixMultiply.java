package ch4_divide_conquer.sec2_matrix_multiplication;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by dleung on 9/28/15.
 */
public class MatrixMultiply {
    public static void main(String[] args) {
        Matrix a;
        try {
            a = new Matrix(Arrays.asList(1, 2), 2);
        } catch(Exception e) {
            System.out.println(e);
            return;
        }

        Matrix b;
        try {
            b = new Matrix(Arrays.asList(1, 2), 1);
        } catch(Exception e) {
            System.out.println(e);
            return;
        }

        System.out.println("a = " + a);
        System.out.println("b = " + b);
        try {
            System.out.println("a x b = " + multiply(a, b));
        } catch(Exception e) {
            System.out.println(e);
        }
    }

    public static Matrix multiply(Matrix a, Matrix b) throws Exception {
        int bRows = b.elements.size();
        int aRows = a.elements.size();
        int aColumns = a.elements.get(0).size();
        int bColumns = b.elements.get(0).size();

        if (aRows != bColumns) {
            throw new Exception("A Row size and B column size must be equal");
        }

        List<List<Integer>> result = new ArrayList<List<Integer>>();
        for (int i = 0; i < aRows; i++) {
            List<Integer> rowResult = new ArrayList<Integer>(aColumns);

            for (int j = 0; j < bColumns; j++) {
                Integer sum = 0;
                for (int k = 0; k < bRows; k++) {
                    sum += a.elements.get(i).get(k) * b.elements.get(k).get(j);
                }
                rowResult.add(sum);
            }

            result.add(rowResult);
        }

        return new Matrix(result);
    }
}
