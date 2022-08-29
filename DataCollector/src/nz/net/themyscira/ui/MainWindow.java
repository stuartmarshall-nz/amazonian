package nz.net.themyscira.ui;

import nz.net.themyscira.datamodel.*;

import javafx.event.*;
import javafx.geometry.Orientation;
import javafx.scene.Scene;
import javafx.scene.layout.*;
import javafx.scene.control.Button;
import javafx.stage.Stage;
import javafx.application.*;

public class MainWindow extends Application {

	public void start(Stage stage) {
		System.out.println("in MainWindow::start");
		
		stage.setTitle("Data Collection Utility");
		
		Button showRecords = new Button("Show Records");
		Button addRecord = new Button("Add Record");
		
//		addRecord.setOnAction(new EventHandler<ActionEvent>() {
//			 
//            @Override
//            public void handle(ActionEvent event) {
//                System.out.println("Hello World!");
//            }
//        });
//		

		showRecords.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent event) {
				System.out.println("Hello World!");
			}
		});		
		addRecord.setOnAction((event) -> {
			ExerciseRecord rec = new ExerciseRecord();
			System.out.println("ID of new record is: " + rec.getRecordID());
		}); 
		showRecords.setOnAction((event) -> {
			System.out.println("We have created: " + ExerciseRecord.numRecords());
		});
		
		Pane root = new FlowPane(Orientation.VERTICAL);
		root.getChildren().add(addRecord);
		root.getChildren().add(showRecords);
		
		Scene scene = new Scene(root, 300, 300);
		stage.setScene(scene);
		stage.show();
	}
	
}
