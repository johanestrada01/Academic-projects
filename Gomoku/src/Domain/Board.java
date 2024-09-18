package Domain;

import javax.crypto.Mac;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Objects;
import java.util.Random;

public class Board implements Serializable{
    int len;
    Player player1, player2;
    Box[][] boxes;
    ArrayList<Integer []> temporaries;
    private static Board board;

    private Board(int size, Player player1, Player player2){
        len=size;
        this.player1=player1;
        this.player2=player2;
        boxes=new Box[size][size];
        temporaries = new ArrayList<Integer []>();
    }

    public static Board getBoard(int size, Player player1, Player player2){
        if(board==null){
            board=new Board(size, player1, player2);
        }
        return board;
    }

    public static Board getBoard(){
        return board;
    }

    public void resetBoard(){
        board=null;
    }

    public void addPiece(int row, int column, String color, String type){
        Random random = new Random();
        int typeBox = random.nextInt(15);
        if(boxes[row][column]==null) {
        if(boxes[row][column]==null)
            if (typeBox == 6) {
                Golden newBox = new Golden(color, type);
                boxes[row][column] = newBox;
            } else if (typeBox == 4) {
                Mine newBox = new Mine(color, type);
                boxes[row][column] = newBox;
                Player p = board.getPlayer(color);
                p.addPoints(-50);
            } else if (typeBox == 7) {
                Teleport newBox = new Teleport(color, type);
                boxes[row][column] = newBox;
                newBox.teleport(newBox.getInfo(), row, column);
                Player p = board.getPlayer(color);
                if (!Objects.equals(type, "normal")) {
                    p.addPoints(-100);
                }
            } else {
                Box newBox = new Box(color, type);
                boxes[row][column] = newBox;
            }
        }
        else{
            boxes[row][column].addPiece(color, type);
        }
    }

    public void teleport(String[] data, int row, int column){
        Teleport t=(Teleport) boxes[row][column];
        t.teleport(data,row,column);
    }

    public void addClassic(int row, int column, String color){
        if(boxes[row][column]==null) {
                Box newBox = new Box(color, "normal");
                boxes[row][column] = newBox;
        }
        else{
            boxes[row][column].addPiece(color, "normal");
        }
    }

    public void removePiece(int row, int column){
        boxes[row][column].removePiece();
    }

    public boolean find(int row, int column){

        int[][] xAround=new int[][]{{0,0,0,0,0},{0,0,0,0,0},{1,2,3,4,5},{-1,-2,-3,-4,-5},{1,2,3,4,5},{-1,-2,-3,-4,-5},{1,2,3,4,5},{-1,-2,-3,-4,-5}};
        int[][] yAround=new int[][]{{-1,-2,-3,-4,-5},{1,2,3,4,5},{-1,-2,-3,-4,-5},{1,2,3,4,5},{0,0,0,0,0},{0,0,0,0,0},{1,2,3,4,5},{-1,-2,-3,-4,-5}};
        int direction=0;
        if(boxes[row][column]==null | (boxes[row][column]!=null && boxes[row][column].getPiece()==null)) {
            return false;
        }
        String currentColor=boxes[row][column].getColorPiece();
        int total=boxes[row][column].getweightPiece();
        for(int i=0; i<xAround.length; i++){
            for(int j=0; j<5; j++){
                int newColumn=column+xAround[i][j];
                int newRow=row+yAround[i][j];
                Box box=null;
                if(newColumn<len && newColumn>=0 && newRow<len && newRow>=0){
                    box=boxes[newRow][newColumn];
                }
                if(box!=null && box.getPiece()!=null && Objects.equals(box.getColorPiece(), currentColor)){
                    total+=boxes[newRow][newColumn].getweightPiece();
                }
                else{
                    break;
                }
            }
            direction++;
            if(direction==2){
                direction=0;
                if(total==5){
                    return true;
                }
                total=boxes[row][column].getweightPiece();
            }

        }
        return false;
    }

    public String[] getInfo(int row, int column){
        if( boxes[row][column] != null && boxes[row][column].getPiece() != null){
            return boxes[row][column].getInfo();
        }
        return null;
    }

    public void detonate(int row, int column){
        int[] deleteX=new int[]{0,1,1,1,0,-1,-1,-1};
        int[] deleteY=new int[]{-1,-1,0,1,1,1,0,-1};
        Player detonator=getPlayer(boxes[row][column].getColorPiece());
        boxes[row][column].removePiece();
        for(int i=0; i<deleteX.length; i++){
            int nextDeleteY=row+deleteY[i];
            int nextDeleteX=column+deleteX[i];
            if(nextDeleteX<len && nextDeleteX>=0 && nextDeleteY<len && nextDeleteY>=0) {
                Box b=boxes[nextDeleteY][nextDeleteX];
                if(b!=null) {
                    String color = b.getColorPiece();
                    Player p = getPlayer(color);
                    p.addPoints(-50);
                    boxes[nextDeleteY][nextDeleteX].removePiece();
                    if(p==player1 && detonator==player2){
                        player2.addPoints(100);
                    }
                    else if(p==player2 && detonator==player1){
                        player1.addPoints(100);
                    }
                }
            }
        }
    }

    public int getLen(){
        return len;
    }

    public String getBoxType(int row, int column){
        if(boxes[row][column]==null){
            return null;
        }
        return boxes[row][column].getType();
    }

    public boolean goldIsUsed(int row, int column){
        Golden gold=(Golden)boxes[row][column];
        return gold.isUsed();
    }

    public void useGolden(int row, int column){
        Golden gold=(Golden)boxes[row][column];
        gold.setUsed();
    }

    public void playTemporal(int row, int column){
        Box boxTemporal=boxes[row][column];
        if(boxTemporal!=null){
            boxTemporal.playTemporal();
            if(boxTemporal.getTime()==0){
                boxes[row][column]=null;
            }
        }
    }

    public Player getPlayer(String color){
        if(Objects.equals(color, "white")){
            return player1;
        }
        return player2;
    }

    public void useMine(int row, int colum){
        Mine mine=(Mine)boxes[row][colum];
        mine.use();
    }

    public boolean isUsedMine(int row, int colum){
        Mine mine=(Mine)boxes[row][colum];
        return mine.isUsed();
    }

    public boolean isUsedTeleport(int row, int column){
        Teleport teleport=(Teleport) boxes[row][column];
        return teleport.isUsed();
    }

    public void useTeleport(int row, int column){
        Teleport teleport=(Teleport) boxes[row][column];
        teleport.use();
    }


    public Box[][] getBoxes(){
        return boxes;
    }

    public boolean playMachine() throws GomokuException {
        Machine m=(Machine) player2;
        return m.play("normal");
    }

    public void setBoxes(Box[][] box){
        this.boxes=null;
        this.boxes=box;
    }
}