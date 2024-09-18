package Domain;

import java.io.Serializable;
import java.util.Objects;

public class Box implements Serializable{
    Piece piece;
    String type;

    public Box(String color, String type){
        this.type = type;
        if(Objects.equals(type, "normal")){
            piece=new Piece(color);
        }
        else if(Objects.equals(type, "heavy")){
            piece=new Heavy(color);
        }
        else{
            piece=new Temporary(color);
        }
        Board board=Board.getBoard();
        Player player=board.getPlayer(color);
        if(!Objects.equals(type, "normal")){
            player.addPoints(100);
        }
    }

    public Piece getPiece(){
        return piece;
    }

    public void addPiece(String color, String type){
        this.type = type;
        if(Objects.equals(type, "normal")){
            piece=new Piece(color);
        }
        else if(Objects.equals(type, "heavy")){
            piece=new Heavy(color);
        }
        else{
            piece=new Temporary(color);
        }
        Board board=Board.getBoard();
        Player player=board.getPlayer(color);
        if(!Objects.equals(type, "normal")){
            player.addPoints(100);
        }
    }

    public String getColorPiece(){
        if(piece==null){
            return null;
        }
        return piece.getColor();
    }

    public int getweightPiece(){
        if(piece instanceof Heavy){
            Heavy h=(Heavy)piece;
            return h.getWeight();
        }
        return piece.getWeight();
    }

    public String[] getInfo(){
        if(type==null | piece==null){
            return null;
        }
        return new String[]{type, getColorPiece()};
    }

    public String getType(){
        return "box";
    }

    public void playTemporal(){
        if(piece instanceof Temporary){
            Temporary t=(Temporary) piece;
            t.play();
        }
    }

    public int getTime(){
        if(piece instanceof Temporary){
            Temporary t=(Temporary) piece;
            return t.getTime();
        }
        return 1;
    }

    public void removePiece(){
        this.piece=null;
        type=null;
        System.out.println(getColorPiece()+" deleted piece");
    }

    public String getTypePiece(){
        return type;
    }

}
