package Domain;

import java.io.Serializable;

public class Temporary extends Piece implements Serializable{
    
    private int time;

    public Temporary(String color){
        super(color);
        time = 6;
    }

    public void play(){
        time --;
    }

    public int getTime(){
        return time;
    }
}
