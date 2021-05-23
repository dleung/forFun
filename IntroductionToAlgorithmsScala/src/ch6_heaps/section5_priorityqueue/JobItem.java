package ch6_heaps.section5_priorityqueue;

class JobItem {
    int key; // the priority
    int value; // the contents of the job

    public JobItem(int key, int value) {
        this.key = key;
        this.value = value;
    }

    @Override public String toString() {
        return "(" + key + "," + value + ")";
    }
}