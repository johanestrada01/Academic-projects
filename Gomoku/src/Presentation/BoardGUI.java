package Presentation;

import Domain.Board;
import Domain.Box;
import Domain.Gomoku;
import Domain.GomokuException;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Arrays;
import java.util.Objects;

public class BoardGUI extends JFrame implements Serializable {

    boolean player, win, tie;
    Gomoku domain;
    String name1,name2,mode,rival;
    Box[][] boxes;
    Button[][] buttons;
    int size, segundosP1, segundosP2, minutesP1, minutesP2;
    JLabel tittle, time1, time2, points1, points2, player1Name, player2Name;

    JToggleButton normal, normalP2, heavyP1, heavyP2, temporaryP1, temporaryP2;
    private static BoardGUI boardGui;
    Timer timer1, timer2;
    boolean endTime;

    JMenuItem restart;
    JMenuBar menuBar;
    JMenu menuFile;
    JMenu menuGame;
    JMenuItem save;
    JMenuItem load;
    JMenuItem end;
    JFileChooser fileChooser;
    JPanel player1;

    private BoardGUI(int size, String name1, String name2, String rival, Boolean percentage) {
        super();
        this.rival=rival;
        setLayout(new BorderLayout());
        this.size = size;
        this.name1 = name1;
        this.name2 = name2;
        mode = "Normal";
        buttons = new Button[size][size];
        prepareElements();
        prepareActions();
        domain = new Gomoku(size, name1, name2, "normal", rival, percentage);
        setVisible(true);
        player = true;
        win = false;
        timers();
        update();

    }

    private BoardGUI(int size, String name1, String name2, String type, String rival, Boolean percentage) {
        super();
        this.rival=rival;
        mode=type;
        setLayout(new BorderLayout());
        this.size = size;
        this.name1 = name1;
        this.name2 = name2;
        buttons = new Button[size][size];
        prepareElementsClassic();
        prepareActionsClassic();
        domain = new Gomoku(size, name1, name2, mode, rival, percentage);
        setVisible(true);
        player = true;
        win = false;
        update();
    }

    private BoardGUI(int size, String name1, String name2, int time, String rival, Boolean percentage) {
        super();
        this.rival=rival;
        mode = "Quicktime";
        this.size = size;
        this.name1 = name1;
        this.name2 = name2;
        domain = new Gomoku(size, name1, name2, mode, rival, percentage);
        time=time/2;
        setLayout(new BorderLayout());
        buttons = new Button[size][size];
        segundosP1=time%60;
        minutesP1=time/60;
        segundosP2=time%60;
        minutesP2=time/60;
        prepareElements();
        prepareActions();
        time1.setText("Tiempo: "+ String.format("%02d:%02d", minutesP1, segundosP1));
        time2.setText("Tiempo: "+ String.format("%02d:%02d", minutesP2, segundosP2));
        setVisible(true);
        player = true;
        win = false;
        timersQuicktime();
    }

    private int getSizeBoard(){
        return size;
    }

    private String[] getData(){
        return new String[]{name1, name2, mode, rival};
    }

    public static BoardGUI getBoardGui(int size, String name1, String name2, String mode, String rival) throws GomokuException{
        if(boardGui==null){
            if(Objects.equals(mode, "Normal")) {
                boardGui = new BoardGUI(size, name1, name2, rival, true);
            }
            else if(Objects.equals(mode, "Quicktime")){
                JTextField timeField = new JTextField(10);
                int timeInSeconds = 120;
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese el tiempo (segundos):", timeField},
                        "Configuración de Temporizador", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        timeInSeconds = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        throw new GomokuException(GomokuException.NO_NUMBER);
                    }
                }
                boardGui = new BoardGUI(size, name1, name2, timeInSeconds, rival, true);
            }
            else{
                JTextField timeField = new JTextField(10);
                boardGui = new BoardGUI(size, name1, name2, "classic", rival, true);
            }
        }
        boardGui.update();
        return boardGui;
    }



    private void updateTimeP1(){
        time1.setText("Tiempo: "+ String.format("%02d:%02d", minutesP1, segundosP1));
    }

    private void updateTimeP2(){
        time2.setText("Tiempo: "+ String.format("%02d:%02d", minutesP2, segundosP2));
    }

    public static BoardGUI getBoardGui() {
        boardGui.update();
        return boardGui;
    }

    private void timers(){
        timer1 = new Timer(1000, e -> {
            updateScoreP1();
            if(domain.player() && !win) {
                segundosP1++;
                if(segundosP1==60){
                    minutesP1++;
                    segundosP1=0;
                }
                updateTimeP1();
            }
        });
        timer1.start();

        segundosP2=0;
        timer2 = new Timer(1000, e -> {
            updateScoreP2();
            if(!domain.player() && !win) {
                segundosP2++;
                if(segundosP2==60){
                    minutesP2++;
                    segundosP2=0;
                }
                updateTimeP2();
            }
        });
        timer2.start();
    }

    private void timersQuicktime(){
        timer1 = new Timer(1000, e -> {
            updateScoreP1();
            if(domain.player() && !win && !endTime) {
                if(minutesP1==0 && segundosP1==0){
                    endTime=true;
                    JOptionPane.showMessageDialog(null, "¡Gana " + name2 + "¡", "Winner", JOptionPane.INFORMATION_MESSAGE);
                }
                else if(segundosP1==0){
                    minutesP1--;
                    segundosP1=59;
                }
                else {
                    segundosP1--;
                }
                updateTimeP1();
            }
        });
        timer1.start();

        timer2 = new Timer(1000, e -> {
            updateScoreP2();
            if(!domain.player() && !win && !endTime) {
                if(minutesP2==0 && segundosP2==0){
                    endTime=true;
                    JOptionPane.showMessageDialog(null, "¡Gana " + name1 + "¡", "Winner", JOptionPane.INFORMATION_MESSAGE);
                }
                else if(segundosP2==0){
                    minutesP2--;
                    segundosP2=59;
                }
                else {
                    segundosP2--;
                }
                updateTimeP2();
            }
        });
        timer2.start();
    }

    private void prepareElements() { //Refactorizar con el classic
        setTitle("GOMOKU");
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout());
        JPanel board =new JPanel(new GridLayout(size, size));
        for (int i = 0; i < size * size; i++) {
            Button button = createGridButton((int) i / size, i % size);
            board.add(button);
            buttons[i/size][i%size]=button;
        }
        mainPanel.add(board, BorderLayout.CENTER);
        JPanel tittle = new JPanel();
        JLabel textTittle = new JLabel("GomokuPOOS");
        textTittle.setFont(new Font("MS Gothic", Font.BOLD, 60));
        tittle.setOpaque(false);
        tittle.add(textTittle);
        mainPanel.add(tittle, BorderLayout.NORTH);
        player1=new JPanel();
        player1.setLayout(new BoxLayout(player1, BoxLayout.Y_AXIS));

        player1Name = new JLabel(name1);
        player1Name.setFont(new Font("Arial", Font.PLAIN, 20));
        player1Name.setForeground(Color.GREEN.darker());
        player1.add(player1Name);

        normal=new JToggleButton("Normal");
        player1.add(normal);
        heavyP1 = new JToggleButton("Heavy");
        player1.add(heavyP1);

        temporaryP1 = new JToggleButton("Temporary");
        player1.add(temporaryP1);

        time1=new JLabel("Tiempo "+ " 00:00");
        points1=new JLabel("Puntos: "+0);
        time1.setFont(new Font("Arial", Font.PLAIN, 20));
        points1.setFont(new Font("Arial", Font.PLAIN, 20));
        player1.add(time1);
        player1.add(points1);
        mainPanel.add(player1, BorderLayout.WEST);
        JPanel player2=new JPanel();
        player2.setLayout(new BoxLayout(player2, BoxLayout.Y_AXIS));

        player2Name = new JLabel(name2);
        player2Name.setFont(new Font("Arial", Font.PLAIN, 20));
        player2.add(player2Name);

        normalP2=new JToggleButton("Normal");
        player2.add(normalP2);
        heavyP2 = new JToggleButton("Heavy");
        player2.add(heavyP2);
        temporaryP2 = new JToggleButton("Temporary");
        player2.add(temporaryP2);
        time2=new JLabel("Tiempo "+ " 00:00");
        points2=new JLabel("Puntos: "+0);
        time2.setFont(new Font("Arial", Font.PLAIN, 20));
        points2.setFont(new Font("Arial", Font.PLAIN, 20));
        player2.add(time2);
        player2.add(points2);
        mainPanel.add(player2, BorderLayout.EAST);
        board.setBorder(BorderFactory.createLineBorder(Color.BLACK, 2));
        add(mainPanel, BorderLayout.CENTER);
        setPreferredSize(new Dimension(500, 500));
        pack();

        menuBar = new JMenuBar();
        menuFile = new JMenu("File");
        save = new JMenuItem("Save");
        load = new JMenuItem("Load");

        menuFile.add(save);
        menuFile.addSeparator();
        menuFile.add(load);
        menuBar.add(menuFile);

        menuGame = new JMenu("Game");
        restart = new JMenuItem("Restart");
        end = new JMenuItem("End Game");

        menuGame.add(restart);
        menuGame.addSeparator();
        menuGame.add(end);

        menuBar.add(menuGame);

        setJMenuBar(menuBar);

        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
    private void prepareElementsClassic() {
        setTitle("GOMOKU");
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout());
        JPanel board =new JPanel(new GridLayout(size, size));
        for (int i = 0; i < size * size; i++) {
            Button button = createGridButton((int) i / size, i % size);
            board.add(button);
            buttons[i/size][i%size]=button;
        }
        mainPanel.add(board, BorderLayout.CENTER);
        JPanel tittle = new JPanel();
        JLabel textTittle = new JLabel("GomokuPOOS");
        textTittle.setFont(new Font("MS Gothic", Font.BOLD, 60));
        tittle.setOpaque(false);
        tittle.add(textTittle);
        mainPanel.add(tittle, BorderLayout.NORTH);
        JPanel player1=new JPanel();
        player1.setLayout(new BoxLayout(player1, BoxLayout.Y_AXIS));
        player1Name = new JLabel(name1);
        player1Name.setFont(new Font("Arial", Font.PLAIN, 20));
        player1Name.setForeground(Color.GREEN.darker());
        player1.add(player1Name);
        normal=new JToggleButton("Normal");
        player1.add(normal);
        mainPanel.add(player1, BorderLayout.WEST);
        JPanel player2=new JPanel();
        player2.setLayout(new BoxLayout(player2, BoxLayout.Y_AXIS));
        player2Name = new JLabel(name2);
        player2Name.setFont(new Font("Arial", Font.PLAIN, 20));
        player2.add(player2Name);
        normalP2=new JToggleButton("Normal");
        player2.add(normalP2);
        mainPanel.add(player2, BorderLayout.EAST);
        board.setBorder(BorderFactory.createLineBorder(Color.BLACK, 2));
        add(mainPanel, BorderLayout.CENTER);
        setPreferredSize(new Dimension(500, 500));
        pack();

        menuBar = new JMenuBar();
        menuFile = new JMenu("File");
        save = new JMenuItem("Save");
        load = new JMenuItem("Load");

        menuFile.add(save);
        menuFile.addSeparator();
        menuFile.add(load);
        menuBar.add(menuFile);

        menuGame = new JMenu("Game");
        restart = new JMenuItem("Restart");
        end = new JMenuItem("End Game");

        menuGame.add(restart);
        menuGame.addSeparator();
        menuGame.add(end);

        menuBar.add(menuGame);

        setJMenuBar(menuBar);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }



    private Button createGridButton(int row, int column) {
        Button button = new Button(row, column);
        button.setBorder(BorderFactory.createLineBorder(Color.BLACK, 2));
        button.setFocusPainted(false);
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    actionPlay(button.getPositions());
                } catch (GomokuException ex) {
                    JOptionPane.showMessageDialog(null, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
        button.setBackground(new Color(185, 140, 100));
        return button;
    }

    public String play(){
        if(Objects.equals(mode, "classic")){
            return "normal";
        }
        String type;
        if (domain.player()) {
            if(heavyP1.isSelected()){
                type = "heavy";
            }
            else if(temporaryP1.isSelected()){
                type = "temporary";
            }
            else{
                type = "normal";
            }
        }
        else {
            if(heavyP2.isSelected()){
                type = "heavy";
            }
            else if(temporaryP2.isSelected()){
                type = "temporary";
            }
            else{
                type = "normal";
            }
        }
        return type;
    }

    private void actionPlay(int[] positions) throws GomokuException {
        if(!win && !tie) {
            domain.actionPlay(positions, play());
            String winner=domain.getWinner();
            update();
            if(winner!=null && !Objects.equals(winner, "no")){
                win=true;
                int endSelect = JOptionPane.showOptionDialog(this, "Winer " + winner, "End Game",  JOptionPane.YES_NO_CANCEL_OPTION,
                        JOptionPane.QUESTION_MESSAGE,
                        null,
                        new String[]{"Restart", "Menu", "Cancel"},
                        "Menu");

                if(endSelect==JOptionPane.YES_OPTION){
                    restart();
                }

                else{
                    getBoardGui().dispose();
                    if(mode == "Quicktime"){
                        timer1.stop();
                        timer2.stop();
                        timer1 = null;
                        timer2 = null;
                    }
                    boardGui = null;
                    domain.resetBoard();
                    ConfigGUI.getConfigGUI().setVisible(true);
                }

            }
            if(Objects.equals("no", winner)){
                tie=true;
                JOptionPane.showMessageDialog(null, "¡Empate¡", "Empate", JOptionPane.INFORMATION_MESSAGE);
            }
        }
        update();
    }

    private void prepareActions(){
        normal.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                heavyP1.setSelected(false);
                temporaryP1.setSelected(false);
            }
        });

        heavyP1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                normal.setSelected(false);
                temporaryP1.setSelected(false);

            }
        });

        temporaryP1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                normal.setSelected(false);
                heavyP1.setSelected(false);
            }
        });

        normalP2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                heavyP2.setSelected(false);
                temporaryP2.setSelected(false);

            }
        });

        heavyP2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                normalP2.setSelected(false);
                temporaryP2.setSelected(false);

            }
        });

        temporaryP2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                normalP2.setSelected(false);
                heavyP2.setSelected(false);
            }
        });

        save.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                save();
            }
        });

        end.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                getBoardGui().dispose();
                if(mode == "Quicktime"){
                    timer1.stop();
                    timer2.stop();
                    timer1 = null;
                    timer2 = null;
                }
                boardGui = null;
                domain.resetBoard();
                ConfigGUI.getConfigGUI().setVisible(true);

            }
        });

        restart.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                try{
                    restart();
                }
                catch(GomokuException e){
                    System.out.println(e.getMessage());
                }

            }
        });
    }

    private void save() {
        boxes=Board.getBoard().getBoxes();
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setDialogTitle("save");
        int userSelection = fileChooser.showSaveDialog(null);
        if (userSelection == JFileChooser.APPROVE_OPTION) {
            try {
                String filePath = fileChooser.getSelectedFile().getAbsolutePath();
                if (!filePath.endsWith(".dat")) {
                    filePath += ".dat";
                }
                try (ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(filePath))) {
                    objectOutputStream.writeObject(this);
                    JOptionPane.showMessageDialog(null, " save");
                    objectOutputStream.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
                JOptionPane.showMessageDialog(null, "Error al guardar el archivo.");
            }
        }
    }
    private void restart() throws GomokuException{
        if(mode == "Normal"){
            boardGui.dispose();
            domain.resetBoard();
            boardGui = new BoardGUI(size, name1, name2,rival, true);
        }

        else if(mode == "Quicktime"){
            boardGui.dispose();
            domain.resetBoard();
            timer1.stop();
            timer2.stop();
            timer1 = null;
            timer2 = null;
            boardGui = null;

            boardGui = getBoardGui(size, name1, name2, mode, rival);

        }

        else{
            boardGui.dispose();
            domain.resetBoard();
            boardGui = null;
            boardGui = getBoardGui(size, name1, name2, mode, rival);
        }
    }

    private void update(){
        int occupied=0;

        for(int i = 0; i < size ; i++) {
            for (int j = 0; j < size; j++) {
                String[] data = domain.getInfo(i, j);
                Button button = buttons[i][j];
                if(domain.getInfo(i,j)!=null && Objects.equals(domain.getInfo(i, j)[0], "temporary")){
                    domain.playTemporal(i,j);
                }
                if(data != null){
                    button.setImage(data[0]+data[1]);
                    occupied++;
                    if(occupied==Math.pow(size,2)){
                        win=true;
                        tie=true;
                        JOptionPane.showMessageDialog(null, "¡Empate¡", "Empate", JOptionPane.INFORMATION_MESSAGE);
                    }
                }
                else{
                    button.deleteImage();
                }
                if(Objects.equals(domain.getBoxType(i, j), "mine")){
                    button.setBackground(Color.RED);
                }
                else if(Objects.equals(domain.getBoxType(i,j), "teleport")){
                    button.setBackground(Color.BLUE);
                }
                else if(Objects.equals(domain.getBoxType(i,j), "golden")){
                    button.setBackground(new Color(255, 214, 0));
                }
            }
        }
        int[][] stones = domain.getInfoPlayers();

        normal.setText("Normal: " + stones[0][0]);
        if(stones[0][0]==0){
            normal.setEnabled(false);
        }
        else{
            normal.setEnabled(true);
        }
        normalP2.setText("Normal: " + stones[1][0]);
        if(stones[1][0]==0){
            normalP2.setEnabled(false);
        }
        else{
            normalP2.setEnabled(true);
        }

        if(mode=="Normal" || mode=="Quicktime") {
            heavyP1.setText("Heavy: " + stones[0][1]);
            if(stones[0][1]==0){
                heavyP1.setEnabled(false);
            }
            else{
                heavyP1.setEnabled(true);
            }
            temporaryP1.setText("Temporary: " + stones[0][2]);
            if(stones[0][2]==0){
                temporaryP1.setEnabled(false);
            }
            else{
                temporaryP1.setEnabled(true);
            }
            heavyP2.setText("Heavy: " + stones[1][1]);
            if(stones[1][1]==0){
                heavyP2.setEnabled(false);
            }
            else{
                heavyP2.setEnabled(true);
            }
            temporaryP2.setText("Temporary: " + stones[1][2]);
            if(stones[1][2]==0){
                temporaryP2.setEnabled(false);
            }
            else{
                temporaryP2.setEnabled(true);
            }

        }


        if(domain.player()){
            player1Name.setForeground(Color.GREEN);
            player2Name.setForeground(Color.BLACK);
        }
        else{
            player2Name.setForeground(Color.GREEN);
            player1Name.setForeground(Color.BLACK);
        }
    }
    private void updateScoreP1(){
        int points=domain.getPoints("white");
        points1.setText("Puntos "+points);
    }

    private void updateScoreP2(){
        int points=domain.getPoints("black");
        points2.setText("Puntos "+points);
    }

    private void prepareActionsClassic(){
        save.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                fileChooser = new JFileChooser();
                fileChooser.showSaveDialog(rootPane);
                File file = fileChooser.getSelectedFile();
                JOptionPane.showMessageDialog(null, "Saved Game");
            }
        });

        end.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                getBoardGui().dispose();
                boardGui = null;
                domain.resetBoard();
                ConfigGUI.getConfigGUI().setVisible(true);
            }
        });


        restart.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev){
                try{
                    restart();
                }
                catch(GomokuException e){
                    System.out.println(e.getMessage());
                }

            }
        });
    }

    public Box[][] getBoxes(){
        return boxes;
    }
    public static void loadGame(BoardGUI board) throws GomokuException {
        BoardGUI.getBoardGui(board).setVisible(true);
    }

    public static BoardGUI getBoardGui(BoardGUI board) throws GomokuException{
        String[] data=board.getData();
        int size= board.getSizeBoard();
        if(boardGui==null){
            if(Objects.equals(board.getMode(), "Normal")) {
                boardGui = new BoardGUI(size, data[0], data[1], data[3], false);
                boardGui.setTimeP1(board.getTimeP1());
                boardGui.setTimeP2(board.getTimeP2());
                boardGui.domain.setStonesP1(board.domain.getStonesP1());
                boardGui.domain.setStonesP2(board.domain.getStonesP2());
                boardGui.setPoints(board.getPoints());
            }
            else if(Objects.equals(board.getMode(), "Quicktime")){
                int timeInSeconds = 120;
                boardGui = new BoardGUI(size, data[0], data[1], timeInSeconds, data[3], false);
                boardGui.setTimeP1(board.getTimeP1());
                boardGui.setTimeP2(board.getTimeP2());
                boardGui.domain.setStonesP1(board.domain.getStonesP1());
                boardGui.domain.setStonesP2(board.domain.getStonesP2());
                boardGui.setPoints(board.getPoints());
            }
            else{
                boardGui = new BoardGUI(size, data[0], data[1], "classic", data[3], false);
                boardGui.domain.setStonesP1(board.domain.getStonesP1());
                boardGui.domain.setStonesP2(board.domain.getStonesP2());
                boardGui.setPoints(board.getPoints());
            }
        }
        Board.getBoard().setBoxes(board.boxes);
        boardGui.update();
        return boardGui;
    }

    public int[] getPoints(){
        return new int[]{domain.player1.getPoints(), domain.player2.getPoints()};
    }

    public void setPoints(int[] points){
        domain.player1.addPoints(points[0]);
        domain.player2.addPoints(points[1]);
    }
    public void setTimeP1(int[] time) {
        segundosP1=time[1];
        minutesP1=time[0];
    }

    public void setTimeP2(int[] time) {
        segundosP1=time[1];
        minutesP1=time[0];
    }

    public int[] getTimeP1(){
        return new int[]{minutesP1, segundosP1};
    }

    public int[] getTimeP2(){
        return new int[]{minutesP2, segundosP2};
    }

    public String getMode(){
        return mode;
    }

}