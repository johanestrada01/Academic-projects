package Domain;

import java.io.Serializable;

public class Human extends Player implements Serializable{
    public Human(int percent, String name, String color, int size){
        super(percent, name, color, size);
    }
    public Human(String name, String color, int size, int numberStones){
        super(name, color, size, numberStones);
    }
    public void play(int row, int column, String type) throws GomokuException{
        generatePiece(row, column, type);
    }
}
