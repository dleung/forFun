package ch4_divide_conquer.sec2_matrix_multiplication;

import java.util.ArrayList;
import java.util.List;

public class Matrix {
    List<List<Integer>> elements = new ArrayList<List<Integer>>();

    public Matrix(List<List<Integer>> newElements) {
        elements = newElements;
    }

    public Matrix(int rows, int cols) {
        for (int row = 0; row < rows; row ++) {
            List<Integer> col = new ArrayList();
            for (int j = 0; j < cols; j ++) {
                col.add(0);
            }
            elements.add(col);
        }
    }

    public Matrix(List<Integer> values, int rowSize) throws Exception {
        if (values.size() % rowSize != 0) {
            throw new Exception("Size of values must be divisible by rowSize");
        }

        int rows = values.size() / rowSize;
        int curRow = 1;
        int from = 0;
        int to = rowSize;

        while (curRow <= rows) {
            elements.add(values.subList(from, to));

            from += rowSize;
            to += rowSize;
            curRow ++;
        }
    }

    public void merge(int row, int col, Matrix newElements) throws Exception {
        for (int newRow = 0; newRow < newElements.elements.size(); newRow ++) {
            ArrayList<Integer> origRow = new ArrayList(elements.get(row));

            int newCol = col;
            for (int j = 0; j < newElements.elements.size(); j ++) {
                origRow.set(newCol, newElements.elements.get(newRow).get(j));
                newCol++;
            }

            elements.set(row, origRow);
            row++;
        }
    }

    public Matrix add(Matrix b) throws Exception {
        if (elements.size() != b.elements.size() || elements.get(0).size() != b.elements.get(0).size()) {
            throw new Exception("A and B size must be equal when adding");
        }

        List<List<Integer>> results = new ArrayList(elements);

        for (int i = 0; i < elements.size(); i ++) {
            List<Integer> row = new ArrayList(elements.get(i));
            for (int j = 0; j < elements.get(0).size(); j++) {
                row.set(j, row.get(j) + b.elements.get(i).get(j));
            }
            results.set(i, row);
        }

        return new Matrix(results);
    }

    public Matrix subMatrix(int tlr, int tlc, int brr, int brc)  throws Exception {
        int rowSize = elements.size();
        int colSize = elements.get(0).size();

        if (tlc >= colSize || brc >= colSize) {
            throw new Exception("Column index exceed column size");
        } else if (tlr >= rowSize || brr >= rowSize) {
            throw new Exception("Row index exceed row size");
        }

        List<List<Integer>> results = new ArrayList();
        for (int row = tlr; row <= brr; row ++) {
            List<Integer> resultRow = new ArrayList();
            for (int col = tlc; col <= brc; col ++) {
                resultRow.add(elements.get(row).get(col));
            }

            results.add(resultRow);
        }

        return new Matrix(results);
    }

    @Override public String toString() {
        return elements.toString();
    }
}
