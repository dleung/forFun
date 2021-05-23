package ch4_divide_conquer.sec2_matrix_multiplication;

import java.util.Arrays;

/**
 * Created by dleung on 9/28/15.
 */
public class SquareMatrixMultiplyRecursive {
    public static void main(String[] args) {
        Matrix a;
        try {
            a = new Matrix(Arrays.asList(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), 4);
        } catch(Exception e) {
            System.out.println(e);
            return;
        }

        Matrix b;
        try {
            b = new Matrix(Arrays.asList(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), 4);
        } catch(Exception e) {
            System.out.println(e);
            return;
        }

        int bRows = b.elements.size();
        int aRows = a.elements.size();
        int aColumns = a.elements.get(0).size();
        int bColumns = b.elements.get(0).size();

        if (aRows != aColumns || bRows != bColumns) {
            System.out.println("A and B must be a square matrix");
            return;
        } else if (aRows != bRows) {
            System.out.println("A needs to have the same number of rows as B");
            return;
        } else if ((Math.log(aRows) / Math.log(2)) % 2 != 0) {
            System.out.println("n needs to be a multiple of 2^x");
            return;
        }


        try {
            System.out.println("a x b = " + squareMultiplyRecursive(a, b));
        } catch(Exception e) {
            System.out.println(e);
        }
    }

    public static Matrix squareMultiplyRecursive(Matrix a, Matrix b) throws Exception {
        Matrix resultMatrix;

        int aRows = a.elements.size();
        int aCols = a.elements.get(0).size();

        int bRows = b.elements.size();
        int bCols = b.elements.get(0).size();

        if (aRows == 1 || aCols == 1) {
            return MatrixMultiply.multiply(a, b);
        } else {
            resultMatrix = new Matrix(aRows, bCols);

            int midpointArow = (aRows - 1) / 2;
            int midpointAcol = (aCols - 1) / 2;
            int midpointBrow = (bRows - 1) / 2;
            int midpointBcol = (bCols - 1) / 2;

            Matrix A11 = a.subMatrix(0, 0, midpointArow, midpointAcol);
            Matrix A12 = a.subMatrix(0, midpointAcol + 1, midpointArow, aCols - 1); // 0, 1, 0, 1
            Matrix A21 = a.subMatrix(midpointArow + 1, 0, aRows - 1, midpointAcol) ; // 1, 0, 1, 0
            Matrix A22 = a.subMatrix(midpointArow + 1, midpointAcol + 1, aRows - 1, aCols - 1);

            Matrix B11 = b.subMatrix(0, 0, midpointBrow, midpointBcol); // 0, 0, 0, 0
            Matrix B12 = b.subMatrix(0, midpointBcol + 1, midpointBrow, bCols - 1); // 0, 1, 0, 1
            Matrix B21 = b.subMatrix(midpointBrow + 1, 0, bRows - 1, midpointBcol) ; // 1, 0, 1, 0
            Matrix B22 = b.subMatrix(midpointBrow + 1, midpointBcol + 1, bRows - 1, bCols - 1);

            Matrix C11a = squareMultiplyRecursive(A11, B11);
            Matrix C11b = squareMultiplyRecursive(A12, B21);
            Matrix C11 = C11a.add(C11b);
            resultMatrix.merge(0, 0, C11);

            Matrix C12a = squareMultiplyRecursive(A11, B12);
            Matrix C12b = squareMultiplyRecursive(A12, B22);
            Matrix C12 = C12a.add(C12b);
            resultMatrix.merge(0, midpointAcol+1, C12);

            Matrix C21a = squareMultiplyRecursive(A21, B11);
            Matrix C21b = squareMultiplyRecursive(A22, B21);
            Matrix C21 = C21a.add(C21b);
            resultMatrix.merge(midpointArow+1, 0, C21);

            Matrix C22a = squareMultiplyRecursive(A21, B12);
            Matrix C22b = squareMultiplyRecursive(A22, B22);
            Matrix C22 = C22a.add(C22b);
            resultMatrix.merge(midpointArow+1, midpointArow+1, C22);
        }

        return resultMatrix;
    }
}
