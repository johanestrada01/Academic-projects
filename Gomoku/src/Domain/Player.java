package Domain;

import java.io.Serializable;
import java.time.Duration;
import java.util.Arrays;
import java.util.Objects;
import java.util.Random;

public abstract class Player implements Serializable{
    private String color, name;
    private int size, percent;
    protected int[] numberStones;
    private int score;
    private boolean isClassic;

    public Player(int percent, String name, String color, int size){
        this.color=color;
        this.name=name;
        this.size=size;
        this.percent=percent;
        numberStones = new int[3];
        assignStones();
    }

    public Player(String name, String color, int size, int n){
        this.color=color;
        this.name=name;
        this.size=size;
        stonesClassic(n);
        isClassic=true;
    }

    public void stonesClassic(int n){
        numberStones=new int[]{n};
        isClassic=true;
    }

    public void generatePiece(int row, int column, String type) throws GomokuException{
        Board board=Board.getBoard();
        if(Objects.equals(type, "normal")){
            if(numberStones[0]==0){
                Log.record(new GomokuException(GomokuException.NO_PIECE));
                throw new GomokuException(GomokuException.NO_PIECE);
            }
            numberStones[0] -= 1;
        }
        else if(Objects.equals(type, "heavy") && numberStones.length>1){
            if(numberStones[1]==0){
                Log.record(new GomokuException(GomokuException.NO_PIECE));
                throw new GomokuException(GomokuException.NO_PIECE);
            }
            numberStones[1] -= 1;
        }
        else if(Objects.equals(type, "temporary") && numberStones.length>1){
            if(numberStones[2]==0){
                Log.record(new GomokuException(GomokuException.NO_PIECE));
                throw new GomokuException(GomokuException.NO_PIECE);
            }
            numberStones[2] -= 1;
        }
        if(!isClassic && numberStones[0]==0 && numberStones[1]==0 &&numberStones[2]==0){
            assignStones();
        }
        if(isClassic){
            board.addClassic(row, column, color);
        }
        else {
            board.addPiece(row, column, color, type);
        }
    }

    private void assignStones(){
        int max = (int) Math.pow(size, 2)*percent/100;
        numberStones[0]=(int) Math.pow(size, 2)-max;
        for(int i=1;i<2 && max>0;i++){
            Random random = new Random();
            int piece = random.nextInt(max) + 1;
            numberStones[i] = piece;
            max -= piece;
        }
        numberStones[2] = max;
    }

    public String getColor(){
         return color;
    }

    public int[] getStones(){
        return numberStones;
    }

    public void addPiece(int index){
        numberStones[index]+=1;
    }

    public void addPoints(int points){
        score+=points;
        if(score>=1000){
            score-=1000;
            Random radom=new Random();
            int n= radom.nextInt(3);
            numberStones[n]+=1;
        }
    }

    public int getPoints(){
        return score;
    }

    public boolean endClassic(){
        return isClassic&&numberStones[0]==0;
    }

    public String getName(){return name;}

    public void setStones(int[] stones){
        this.numberStones=stones;
    }
}
