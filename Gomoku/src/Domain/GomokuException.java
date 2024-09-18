package Domain;

import java.io.Serializable;

public class GomokuException extends Exception implements Serializable{
    public static String NO_PIECE = "Ficha agotada";
    public static String NO_NUMBER="Ingrese numeros";
    public static String INVALID_NUMBER="Tamaño invalido";
    public GomokuException(String message){
        super(message);
    }
}
