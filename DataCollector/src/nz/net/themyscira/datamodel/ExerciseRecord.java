package nz.net.themyscira.datamodel;

public class ExerciseRecord {

	private static int nextRecordID = 1;
	private int recordID;
	private String data;
	
	public ExerciseRecord() {
		this.recordID = nextRecordID++;
		this.data = "placeholder data";
	}
	
	public int getRecordID() {
		return this.recordID;
	}
	
	public void setData(String newData) {
		this.data = newData;
	}
	
	public static int numRecords() {
		return nextRecordID - 1;
	}
	
	public void print() {
		System.out.println("data: " + this.data);
	}
	
}
