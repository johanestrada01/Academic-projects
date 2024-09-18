package Domain;

import java.io.Serializable;

public class Piece implements Serializable{
    protected String color;

    public Piece(String color){
        this.color=color;
    }

    public String getColor(){
        return color;
    }

    
    public int getWeight(){
        return 1;
    }
}
