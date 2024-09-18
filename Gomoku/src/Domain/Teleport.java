package Domain;

import java.io.Serializable;
import java.util.Random;

public class Teleport extends Box implements Serializable{
    boolean used;
    public Teleport(String color, String type){
        super(color, type);
    }

    @Override
    public String getType(){
        return "teleport";
    }

    public boolean isUsed(){
        return used;
    }

    public void use(){
        used=true;
    }

    public void teleport(String[] data, int row, int column){
        Board board=Board.getBoard();
        board.removePiece(row, column);
        Random random=new Random();
        int max= board.getLen();
        int newRow= random.nextInt(max-1);
        int newColumn= random.nextInt(max-1);
        if(board.getInfo(newRow,newColumn)==null) {
            board.addPiece(newRow, newColumn, data[1], data[0]);
        }
        else{
            teleport(data, row, column);
        }
        use();
    }
}
