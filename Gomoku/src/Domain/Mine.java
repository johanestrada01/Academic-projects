package Domain;

import java.io.Serializable;

public class Mine extends Box implements Serializable{
    boolean use;
    public Mine(String color, String type){
        super(color, type);
    }
    @Override
    public String getType(){
        return "mine";
    }

    public boolean isUsed(){
        return use;
    }

    public void use(){
        use=true;
    }
}
