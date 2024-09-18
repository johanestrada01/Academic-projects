package Domain;

import java.io.Serializable;
import java.util.Random;

public class Golden extends Box implements Serializable{
    private boolean used;
    public Golden(String color, String type){
        super(color, type);
        used=false;
    }

    public boolean isUsed(){
        return used;
    }

    public void setUsed(){
        used=true;
    }

    @Override
    public String getType(){
        return "golden";
    }

}
