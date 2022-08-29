package nz.net.themyscira;

import nz.net.themyscira.ui.*;

//import nz.net.themyscira.datamodel.*;
import javafx.application.Application;


public class MainClass {

	public static void main(String[] args) {
		System.out.println(args.length + " arguments received");
		
//		MainWindow win = new MainWindow();
		
		Application.launch(MainWindow.class, args);
	}
	
	
	
}
