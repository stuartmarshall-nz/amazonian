package nz.net.themyscira.datamodel;

public class ExerciseRecord {

	private static int nextRecordID = 1;
	private int recordID;
	
	public ExerciseRecord() {
		this.recordID = nextRecordID++;
	}
	
	public int getRecordID() {
		return this.recordID;
	}
	
}
