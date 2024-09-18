package Domain;

import Presentation.Button;

import javax.swing.*;
import java.awt.*;
import java.io.Serializable;
import java.util.Arrays;
import java.util.Objects;
import java.util.Random;

public class Gomoku implements Serializable{
    public Player player1;
    public Player player2;
    boolean machine, player, win, normalGolden, percentage, endClassic;
    Board board;
    String typeGame, winner;
    int goldenTurn;

    public Gomoku(int size, String name1, String name2, String mode, String rival, boolean percentage){
        this.percentage=percentage;
        typeGame=mode;
        if(Objects.equals(rival, "Humano")){
            generateHumanPlayers(size, name1, name2);
        }
        else if(Objects.equals(rival, "Maquina miedosa")){
            generateFunkyPlayer(size, name1, name2);
        }
        else if(Objects.equals(rival, "Maquina experta")){
            generateExpertPlayer(size, name1, name2);
        }else if (Objects.equals(rival, "Maquina agresiva")) {
            generateAgresivePlayer(size, name1, name2);
        }
        board=Board.getBoard(size, player1, player2);
        player=true;
        goldenTurn = 0;
        normalGolden = false;
    }
    public void generateHumanPlayers(int size, String name1, String name2){
        int numberPieces = 0;
        if(Objects.equals(typeGame, "classic")) {
            if(percentage){
            JTextField timeField = new JTextField(10);
            int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese la cantidad de piedras:", timeField},
                    "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

            if (result == JOptionPane.OK_OPTION) {
                try {
                    numberPieces = Integer.parseInt(timeField.getText());
                } catch (NumberFormatException e) {
                    JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                    numberPieces = 10;
                }
            }
        }
            player1 = new Human(name1, "white", size, numberPieces);
            player2 = new Human(name2, "black", size, numberPieces);
        }
        else {
            if(percentage) {
                JTextField timeField = new JTextField(10);
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese el porcentaje de piedras especiales:", timeField},
                        "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        numberPieces = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                        numberPieces = 50;
                    }
                }
            }
            player1 = new Human(numberPieces, name1, "white", size);
            player2 = new Human(numberPieces, name2, "black", size);
        }
    }

    public int[] getStonesP1(){
        return player1.getStones();
    }

    public void setStonesP1(int[] stones){
        player1.setStones(stones);
    }

    public int[] getStonesP2(){
        return player2.getStones();
    }

    public void setStonesP2(int[] stones){
        player2.setStones(stones);
    }


    private void generateFunkyPlayer(int size, String name1, String name2){
        machine=true;
        int numberPieces=10;
        if(Objects.equals(typeGame, "classic")) {
            if(percentage){
            JTextField timeField = new JTextField(10);
            int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese la cantidad de piedras:", timeField},
                    "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
            if (result == JOptionPane.OK_OPTION) {
                try {
                    numberPieces = Integer.parseInt(timeField.getText());
                } catch (NumberFormatException e) {
                    JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);

                }
            }
        }
            player1 = new Human(name1, "white", size, numberPieces);
            player2 = new Funky(name2, "black", size, numberPieces);
        }
        else {
            if(percentage) {
                JTextField timeField = new JTextField(10);
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese el porcentaje de piedras especiales:", timeField},
                        "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        numberPieces = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                        numberPieces = 50;
                    }
                }
            }
            player1 = new Human(numberPieces, name1, "white", size);
            player2 = new Funky(numberPieces, name2, "black", size);
        }
    }

    private void generateAgresivePlayer(int size, String name1, String name2){
        machine=true;
        int numberPieces = 0;
        if(Objects.equals(typeGame, "classic")) {
            if(percentage){
                JTextField timeField = new JTextField(10);
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese la cantidad de piedras:", timeField},
                        "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        numberPieces = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                        numberPieces = 10;
                    }
                }
            }
            player1 = new Human(name1, "white", size, numberPieces);
            player2 = new Aggressive(name2, "black", size, numberPieces);
        }
        else {
            if(percentage) {
                JTextField timeField = new JTextField(10);
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese el porcentaje de piedras especiales:", timeField},
                        "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        numberPieces = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                        numberPieces = 50;
                    }
                }
            }
            player1 = new Human(numberPieces, name1, "white", size);
            player2 = new Aggressive(numberPieces, name2, "black", size);
        }
    }

    public void actionPlay(int[] positions, String type) throws GomokuException {
        Human currentPlayer;
        if(player){
            currentPlayer= (Human) player1;
        }
        else{
            currentPlayer= (Human) player2;
        }
        if(!win) {
            playHuman(positions, currentPlayer, type);
            if (isMachine() && !player) {
                playMachine();
                player = !player;
            }
        }
        if(Objects.equals(typeGame, "classic")){
            if(player1.getStones()[0]==0 && player2.getStones()[0]==0){
                endClassic=true;
            }
        }
        if(endClassic){
            winner="no";
        }
    }

    private void playMachine() throws GomokuException {
        win = board.playMachine();
        if(win){
            winner=player2.getName();
            if(winner==null){
                winner="Maquina";
            }
        }
        refresh();
    }

    private void playHuman(int[] positions, Human currentPlayer, String type) throws GomokuException{
        if (board.getInfo(positions[0], positions[1]) == null) {
            if(normalGolden){
                if(goldenTurn < 1){
                    goldenTurn += 1;
                    player = !player;
                }
                else{
                    normalGolden = false;
                    goldenTurn = 0;
                }
                
            }

            else{
                player = !player;
            }
            try {
                currentPlayer.play(positions[0], positions[1], type);
                refresh();
                win =find(positions[0], positions[1]);
                if(win){
                    winner=currentPlayer.getName();
                }
            } catch (GomokuException e1) {
                player = !player;
                JOptionPane.showMessageDialog(null, e1.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
        refresh();
    }

    private void refresh(){
        int size= board.getLen();
        for(int i = 0; i < size ; i++){
            for(int j = 0; j<size; j++){
                String typeBox=getBoxType(i,j);
                if(Objects.equals(typeBox, "mine") && !isUsedMine(i,j)){
                    detonate(i,j);
                    useMine(i,j);
                }
                if(Objects.equals(typeBox, "teleport") && !isUsedTeleport(i,j)){
                    String[] data = getInfo(i, j);
                    teleport(data, i, j);
                    useTeleport(i,j);
                    refresh();
                }
                if(Objects.equals(typeBox, "golden") && !goldenIsUsed(i,j)){
                    String[] data = getInfo(i, j);
                    addPiece(data[1]);
                    useGolden(i,j);
                }
            }
        }
    }

    private void generateExpertPlayer(int size, String name1, String name2){
        machine=true;
        int numberPieces = 10;
        if(Objects.equals(typeGame, "classic")) {
            if(percentage){
            JTextField timeField = new JTextField(10);
            int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese la cantidad de piedras:", timeField},
                    "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

            if (result == JOptionPane.OK_OPTION) {
                try {
                    numberPieces = Integer.parseInt(timeField.getText());
                } catch (NumberFormatException e) {
                    JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        }
            player1 = new Human(name1, "white", size, numberPieces);
            player2 = new Expert(name2, "black", size, numberPieces);
        }
        else {
            if(percentage) {
                JTextField timeField = new JTextField(10);
                int result = JOptionPane.showConfirmDialog(null, new Object[]{"Ingrese el porcentaje de piedras especiales:", timeField},
                        "Configuración de piedras", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                    try {
                        numberPieces = Integer.parseInt(timeField.getText());
                    } catch (NumberFormatException e) {
                        JOptionPane.showMessageDialog(null, "Error con los datos ingresados, por defecto se asignan 100 piedras", "Error", JOptionPane.ERROR_MESSAGE);
                    }
                }
            }
            player1 = new Human(numberPieces, name1, "white", size);
            player2 = new Expert(numberPieces, name2, "black", size);
        }
    }

    public boolean find(int row, int column){
        return board.find(row, column);
    }

    public String[] getInfo(int row, int column){
        return board.getInfo(row,column);
    }

    public int[][] getInfoPlayers(){
        return new int[][]{player1.getStones(), player2.getStones()}; 
    }

    public String getBoxType(int row, int column){
        return board.getBoxType(row, column);
    }

    public void detonate(int row, int column){
        board.detonate(row, column);
    }

    public void teleport(String[] data, int row, int column){
       board.teleport(data, row, column);
    }

    public void addPiece(String color){
        if(Objects.equals(color, "white")){
            Random random=new Random();
            int randomNumber = random.nextInt(3);
            player1.addPiece(randomNumber);
            if(randomNumber == 0){
                normalGolden = true;
            }
        }
        else{
            Random random=new Random();
            int randomNumber = random.nextInt(3);
            player2.addPiece(randomNumber);
            if(randomNumber == 0){
                normalGolden = true;
            }
        }
    }

    public boolean goldenIsUsed(int row, int column){
        return board.goldIsUsed(row,column);
    }

    public void useGolden(int row, int column){
        board.useGolden(row, column);
    }

    public void playTemporal(int row, int colum){
        board.playTemporal(row,colum);
    }

    public int getPoints(String player){
        if(Objects.equals(player, "white")){
            return player1.getPoints();
        }
        return player2.getPoints();
    }

    public boolean isUsedMine(int row, int column){
        return board.isUsedMine(row, column);
    }

    public void useMine(int row, int column){
        board.useMine(row, column);
    }

    public boolean isUsedTeleport(int row, int column){
        return board.isUsedTeleport(row, column);
    }

    public void useTeleport(int row, int column){
        board.useTeleport(row, column);
    }

    public boolean isMachine(){
        return machine;
    }

    public boolean player(){
        return player;
    }

    public String getWinner(){
        return winner;
    }

    public int getBoardSize() {
        return board.getLen();
    }

    public void resetBoard(){
        board.resetBoard();
    }


}
