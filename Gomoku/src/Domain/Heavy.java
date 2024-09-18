package Domain;

import java.io.Serializable;

public class Heavy extends Piece implements Serializable{
    public Heavy(String color){
        super(color);
    }

    @Override
    public int getWeight(){
        return 2;
    }
}
