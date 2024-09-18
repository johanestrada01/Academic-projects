package Presentation;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Objects;

public class Button extends JButton {
    private final int row;
    private final int column;
    private String color;

    public Button(int row, int column) {
        super();
        this.row = row;
        this.column = column;
        this.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                resizeImage();
            }
        });;
    }

    public int[] getPositions() {
        return new int[]{row, column};
    }

    public void setImage(String color) {
        if (this.color == null) {
            this.color = color;
            resizeImage();
        }
    }

    private void resizeImage() {
        try {
            if (color != null) {
                String imagePath = color + ".png";
                java.net.URL imageURL = getClass().getResource(imagePath);
                if (imageURL != null) {
                    BufferedImage image = ImageIO.read(imageURL);
                    Image scaledImage = image.getScaledInstance(getWidth(), getHeight(), Image.SCALE_SMOOTH);
                    ImageIcon scaledIcon = new ImageIcon(scaledImage);
                    super.setIcon(scaledIcon);
                } else {
                    System.out.println("La imagen no se encontró: " + imagePath);
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteImage(){
        super.setIcon(null);
        color=null;
    }

    public String getColor() {
        return color;
    }
}
