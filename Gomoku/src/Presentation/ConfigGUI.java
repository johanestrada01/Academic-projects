package Presentation;

import Domain.GomokuException;
import Domain.Log;

import javax.swing.*;
import javax.swing.text.AbstractDocument;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.DocumentFilter;
import java.awt.*;
import java.awt.event.*;

public class ConfigGUI extends JFrame{
    
    JPanel container;
    JPanel tittle;
    JPanel options;
    JLabel textTittle;
    JComboBox modes, rivals;
    JTextField dimentions;
    JButton goBack;
    JButton start;
    public int dimentionSelection;

    private static ConfigGUI configGUI; 
    JTextField player2;
    JTextField player1;

    private ConfigGUI(){
        dimentionSelection = 10;
        prepareElements();
        prepareActions();
        setVisible(true);
    }

    public static ConfigGUI getConfigGUI(){
        if(configGUI==null){
            configGUI = new ConfigGUI();
        }
        return configGUI;
    }

    private void prepareElements(){
        Toolkit toolkit = Toolkit.getDefaultToolkit();
        Dimension screenSize = toolkit.getScreenSize();
        int x = (int) screenSize.getWidth(), y=(int) screenSize.getHeight();
        setLayout(new BorderLayout());
        setSize(x/2+30,y/2);
        setLocation(x/2-x/4,y/2-y/4);
        setTitle("CONFIGURATION");

        container = new JPanel();

        container.setBackground(Color.black);
        
        container.setLocation(0,0);
        container.setSize(x/2,y/2);
        container.setLayout(new BorderLayout());

        tittle = new JPanel();
        textTittle = new JLabel("CONFIGURATION");

        textTittle.setFont(new Font("MS Gothic", Font.BOLD, 60));
        tittle.setOpaque(false);
    
        options = new JPanel();
        options.setLayout(new BoxLayout(options, BoxLayout.Y_AXIS));
        options.setBackground(Color.GRAY);
        options.setOpaque(false);

        String[] modesList = {"Normal","Quicktime","Limitless"};
        modes = new JComboBox<String>(modesList);
        modes.setMaximumSize(new Dimension(200,200));

        JLabel modeText = new JLabel("Mode:");
        modeText.setFont(new Font("MS Gothic", Font.PLAIN, 40));

        options.add(modeText, BorderLayout.EAST);
        options.add(modes, BorderLayout.EAST);
        String[] rivalList= {"Humano", "Maquina miedosa", "Maquina experta", "Maquina agresiva"};
        rivals = new JComboBox<String>(rivalList);
        rivals.setMaximumSize(new Dimension(200,200));

        JLabel rivalsText = new JLabel("Rivals:");
        rivalsText.setFont(new Font("MS Gothic", Font.PLAIN, 40));

        options.add(rivalsText, BorderLayout.EAST);
        options.add(rivals, BorderLayout.EAST);
        
        player1 = new JTextField();
        
        JLabel player1Text = new JLabel("White Pieces Name:");

        JPanel players = new JPanel();
        players.setLayout(new BoxLayout(players, BoxLayout.Y_AXIS));
        players.setOpaque(false);

        player1Text.setFont(new Font("MS Gothic", Font.PLAIN, 40));
        player1.setPreferredSize(new Dimension(200,200));
        player1.setMaximumSize(new Dimension(200,200));

        player2 = new JTextField();
        JLabel player2Text = new JLabel("Black Pieces Name:");


        player2Text.setFont(new Font("MS Gothic", Font.PLAIN, 40));
        player2.setPreferredSize(new Dimension(200,200));
        player2.setMaximumSize(new Dimension(200,200));

        players.add(player1Text);
        players.add(player1);
        players.add(player2Text);
        players.add(player2);
        
        container.add(players, BorderLayout.EAST);

        JLabel dimentionText = new JLabel("Dimentions:");
        dimentionText.setFont(new Font("MS Gothic", Font.PLAIN, 40));

        options.add(dimentionText, BorderLayout.CENTER);
        dimentions = new JTextField();
        dimentions.setMaximumSize(new Dimension(200,200));
        options.add(dimentions, BorderLayout.CENTER);

        goBack = new JButton("Go Back");
        start = new JButton("Start");

        tittle.add(textTittle);
        container.add(tittle, BorderLayout.NORTH);

        JPanel startGoBack = new JPanel();
        startGoBack.setLayout(new BorderLayout());
        startGoBack.add(goBack, BorderLayout.WEST);
        startGoBack.add(start, BorderLayout.EAST);
        startGoBack.setOpaque(false);
        container.add(startGoBack, BorderLayout.SOUTH);
        
        container.add(options, BorderLayout.WEST);
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


        goBack.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                dispose();
                MenuGUI.getMenuGUI().setVisible(true);
            }
        });

        start.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                try {
                    actionPlay();
                } catch (GomokuException ex) {
                    JOptionPane.showMessageDialog(null, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
    }

    private void actionPlay() throws GomokuException{
        String name1 = player1.getText();
        String name2 = player2.getText();
        try {
            boolean s=dimentions.getText().trim().isEmpty();
            if(!s) {
                dimentionSelection = Integer.parseInt(dimentions.getText());
            }
        } catch (NumberFormatException ex) {
            Log.record(new GomokuException(GomokuException.NO_NUMBER));
            throw new GomokuException(GomokuException.NO_NUMBER);
        }
        if(dimentionSelection<10){
            Log.record(new GomokuException(GomokuException.INVALID_NUMBER));
            throw new GomokuException(GomokuException.INVALID_NUMBER);
        }
        String mode= (String) modes.getSelectedItem();
        String rival=(String) rivals.getSelectedItem();
        BoardGUI board = BoardGUI.getBoardGui(dimentionSelection, name1, name2, mode, rival);
        dispose();
    }

}