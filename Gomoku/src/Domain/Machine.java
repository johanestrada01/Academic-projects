package Domain;

import java.io.Serializable;

public abstract class Machine extends Player implements Serializable{
    public Machine(int percentage, String name, String color, int size){
        super(percentage, name, color, size);
    }
    public Machine(String name, String color, int size, int numberStones){
        super(name, color, size, numberStones);
    }
    public abstract boolean play(String type) throws GomokuException;
}
