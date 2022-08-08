package nz.net.themyscira;

import nz.net.themyscira.ui.*;
import nz.net.themyscira.datamodel.*;

public class MainClass {

	public static void main(String[] args) {
		System.out.println(args.length + " arguments received");
		
		MainWindow win = new MainWindow();
		win.show();
		
		ExerciseRecord rec = new ExerciseRecord();
		System.out.println("ID of new record is: " + rec.getRecordID());
	}
	
}
