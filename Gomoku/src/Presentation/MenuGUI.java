package Presentation;

import javax.imageio.ImageIO;
import javax.swing.*;

import Domain.Board;
import Domain.GomokuException;

import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.FileInputStream;
import java.awt.image.BufferedImage;
import java.util.Objects;
import java.io.IOException;
import java.io.ObjectInputStream;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;

public class MenuGUI extends JFrame {

    JPanel container;
    JPanel tittle;
    JLabel textTittle;
    JButton playButton, loadGame;
    private static MenuGUI menuGUI;

    private MenuGUI(){
        prepareElements();
        prepareActions();
        setVisible(true);
    }

    public static MenuGUI getMenuGUI(){
        if(menuGUI==null){
            menuGUI = new MenuGUI();
        }
        return menuGUI;
    }

    private void prepareElements(){
        Toolkit toolkit = Toolkit.getDefaultToolkit();
        Dimension screenSize = toolkit.getScreenSize();
        int x = (int) screenSize.getWidth(), y=(int) screenSize.getHeight();
        setLayout(new BorderLayout());
        setSize(x/2,y/2);
        setLocation(x/2-x/4,y/2-y/4);
        setTitle("MENU");
        container = new JPanel(new BorderLayout());
        container.setBackground(Color.black);
        container.setLocation(0,0);
        container.setSize(x/2,y/2);
        tittle = new JPanel();
        textTittle = new JLabel("GomokuPOOS");
        playButton = new JButton("New Game");
        playButton.setFont(new Font("MS Gothic", Font.BOLD, 40));

        loadGame = new JButton("Load Game");
        loadGame.setFont(new Font("MS Gothic", Font.BOLD, 40));

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        buttonPanel.setOpaque(false);
        buttonPanel.add(playButton);
        buttonPanel.add(loadGame);


        container.add(buttonPanel, BorderLayout.CENTER);
        textTittle.setFont(new Font("MS Gothic", Font.BOLD, 80));
        tittle.setOpaque(false);
        tittle.add(textTittle);
        container.add(tittle, BorderLayout.NORTH);
        add(container);
    }


    private void prepareActions(){
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                int respuesta = JOptionPane.showConfirmDialog(null, "¿Cerrar ventana?", "confirmar", JOptionPane.YES_NO_OPTION);
                if(respuesta==0){
                    System.exit(0);
                }
            }
        });

        playButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                actionPlayButton();
            }
        });

        loadGame.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                BoardGUI boardGui = loadFile();
                if (boardGui != null) {
                    dispose();
                    try {
                        BoardGUI.loadGame(boardGui);
                    } catch (GomokuException ex) {
                        throw new RuntimeException(ex);
                    }
                }
                
            }
        });
    }

    private void actionPlayButton(){
        dispose();
        ConfigGUI.getConfigGUI().setVisible(true);
    }

    private BoardGUI loadFile(){
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("Cargar Archivo");
        int userSelection = fileChooser.showOpenDialog(null);
        if (userSelection == JFileChooser.APPROVE_OPTION) {
            try {
                String filePath = fileChooser.getSelectedFile().getAbsolutePath();
                try (ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(filePath))) {
                    BoardGUI instanciaCargada = (BoardGUI) objectInputStream.readObject();
                    JOptionPane.showMessageDialog(null, "Archivo cargado exitosamente.");
                    return instanciaCargada;
                }

            } catch (Exception e) {
                e.printStackTrace();
                JOptionPane.showMessageDialog(null, "Error al cargar el archivo.");
            }
        }
        return null;
    }


    public static void main(String[] args) {
        MenuGUI gomokuMenu = MenuGUI.getMenuGUI();
    }
}   
