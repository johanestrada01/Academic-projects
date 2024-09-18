package Domain;

import java.io.Serializable;
import java.util.*;

public class Expert extends Machine implements Serializable{
    int row, column;
    String typePiece;
    Set<int[]> pieces;
    public Expert(int percentage, String name, String color, int size) {
        super(percentage, name, color, size);
        row=2;
        column=2;
        pieces=new HashSet<int[]>();
    }

    public Expert(String name, String color, int size, int numberStones) {
        super(name, color, size, numberStones);
        row=2;
        column=2;
        pieces=new HashSet<int[]>();
    }

    @Override
    public boolean play(String type) throws GomokuException {
        find();
        generatePiece(row, column, typePiece);
        return Board.getBoard().find(row, column);
    }


    private void find(){
        boolean endFind=false;
        Box[][] boxes=Board.getBoard().getBoxes();
        if(numberStones.length>1) {
            if (findTwoHeavy()) {
                typePiece = "normal";
                return;
            } else if (findHeavy() && numberStones[1] > 0) {
                return;
            }
        }
        for(int i=1; i< boxes.length && !endFind; i++){
            for(int j=1; j<boxes.length && !endFind; j++){
                if(boxes[i][j] == null) {
                    if (numberStones[0] >= 1 && itsFree(i, j)) {
                        row = i;
                        column = j;
                        typePiece = "normal";
                        endFind = true;
                    } else if (itsFree(i, j)) {
                        row = i;
                        column = j;
                        typePiece = "temporary";
                        endFind = true;
                    }
                }
            }
        }
    }


    private boolean itsFree(int row, int column){
        Box[][] boxes=Board.getBoard().getBoxes();
        int[][] x=new int[][]{{0,0,0,0},{0,0,0,0},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{-1,-2,-3,-4}};
        int[][] y=new int[][]{{-1,-2,-3,-4,},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{0,0,0,0},{0,0,0,0},{1,2,3,4},{-1,-2,-3,-4}};
        boolean free=true;
        for(int i=0; i<x.length; i++){
            for(int j=0; j<x[0].length; j++){
                int newRow=row+y[i][j];
                int newColumn=column+x[i][j];
                if(newRow>=0 && newColumn>=0 && newRow<boxes.length && newColumn<boxes.length) {
                    if (boxes[newRow][newColumn] != null && !Objects.equals(boxes[newRow][newColumn].getColorPiece(), getColor())) {
                        free = false;
                    }
                }
            }
            if(free){
                return true;
            }
            free=true;
        }
        return false;
    }

    private boolean findHeavy(){
        Box[][] boxes=Board.getBoard().getBoxes();
        boolean newElement=false;
        for(int i=0; i<boxes.length; i++){
            for(int j=0; j<boxes.length; j++){
                if(boxes[i][j]!=null){
                    if(Objects.equals(boxes[i][j].getColorPiece(), getColor()) && !contains(pieces, new int[]{i,j})){
                        pieces.add(new int[]{i,j});
                        newElement=true;
                    }
                }
            }
        }
        bestPosition();
        return newElement;
    }
    private boolean findTwoHeavy(){ //pesima practica
        int[] x={0,0,-1,1,-1,1,1,-1};
        int[] y={-1,1,0,0,-1,1,-1,1};
        Box[][] boxes=Board.getBoard().getBoxes();
        boolean newElement=false;
        for(int i=0; i<boxes.length; i++){
            for(int j=0; j<boxes.length; j++){
                if(boxes[i][j]!=null){
                    if(Objects.equals(boxes[i][j].getColorPiece(), getColor()) && Objects.equals(boxes[i][j].getTypePiece(), "heavy")){
                        for(int k=0; k<x.length; k++){
                            int nexRow=i+y[k];
                            int nexColumn=j+x[k];
                            boolean next= nexColumn>=0 && nexColumn<boxes.length && nexRow< boxes.length && nexRow>=0 && boxes[nexRow][nexColumn]!=null;
                            if(next && Objects.equals(boxes[nexRow][nexColumn].getColorPiece(), getColor()) && Objects.equals(boxes[nexRow][nexColumn].getTypePiece(), "heavy")){
                                int nextX=nexColumn+x[k];
                                int nextY=nexRow+y[k];
                                if(nextX>0 && nextY>0 && nextX<boxes.length && nextY<boxes.length && boxes[nextY][nextX]==null){
                                    row=nexRow+y[k];
                                    column=nexColumn+x[k];
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    private void bestPosition(){
        int[] x={0,0,-1,1,-1,1,1,-1};
        int[] y={-1,1,0,0,-1,1,-1,1};
        Box[][] boxes=Board.getBoard().getBoxes();
        int f=0;
        int newRow = 0, newColumn = 0;
        boolean free=true, end = false;
        for(int[] h: pieces){
            for(int i=0; i<x.length && !end; i++){
                f++;
                newColumn=h[1]+x[i];
                newRow=h[0]+y[i];
                if(newColumn>=0 && newRow>0 && newColumn<boxes.length && newRow<boxes.length && boxes[newRow][newColumn]!=null){
                    free=false;
                }
                if(f==2 && free){
                    row=newRow;
                    column=newColumn;
                    typePiece="heavy";
                } else if (f==2) {
                    f=0;
                    free=true;
                }
            }
        }
    }

    private boolean contains(Set<int[]> stones, int[] element){
        for(int[] e: stones){
            if(Arrays.equals(element, e)){
                return true;
            }
        }
        return false;
    }
}
