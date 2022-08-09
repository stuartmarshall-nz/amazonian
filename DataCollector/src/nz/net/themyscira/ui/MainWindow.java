package nz.net.themyscira.ui;

import javafx.scene.Scene;
import javafx.scene.layout.Pane;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import javafx.application.*;

public class MainWindow extends Application {

	public void start(Stage stage) {
		System.out.println("here");
		Text message = new Text(75,100,"Data Collector Utility");
		Pane root = new Pane(message);
		Scene scene = new Scene(root);
		stage.setScene(scene);
		stage.show();
	}
	
}
