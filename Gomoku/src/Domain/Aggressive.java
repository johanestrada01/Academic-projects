package Domain;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Objects;

public class Aggressive extends Machine implements Serializable{
    public Aggressive(int percentage, String name, String color, int size) {
        super(percentage, name, color, size);
    }

    public Aggressive(String name, String color, int size, int numberStones) {
        super(name, color, size, numberStones);
    }

    @Override
    public boolean play(String type) throws GomokuException {
        int[][] xAround=new int[][]{{0,0,0,0},{0,0,0,0},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{-1,-2,-3,-4}};
        int[][] yAround=new int[][]{{-1,-2,-3,-4},{1,2,3,4},{-1,-2,-3,-4},{1,2,3,4},{0,0,0,0},{0,0,0,0},{1,2,3,4},{-1,-2,-3,-4}};
        Box[][] boxes=Board.getBoard().getBoxes();
        int len=boxes.length;
        int cRow = 0, cCol = 0, max = 0;
        int total=0;
        for(int index=0; index<Math.pow(len,2); index++){
            int i=index/len;
            int j=index%len;
            if(boxes[i][j]==null){
                for(int k=0; k<xAround.length; k++) {
                    for (int l = 0; l < 4; l++) {
                        int currentRow = i + yAround[k][l];
                        int currentColumn = j + xAround[k][l];
                        boolean limits = currentColumn >= 0 && currentColumn < len && currentRow >= 0 && currentRow < len;
                        boolean condition=limits && boxes[currentRow][currentColumn] != null && boxes[currentRow][currentColumn].getPiece()==null;
                        if (limits && (boxes[currentRow][currentColumn] == null)) {
                            break;
                        }
                        if (limits && Objects.equals(boxes[currentRow][currentColumn].getColorPiece(), getColor())) {
                            break;
                        }
                        if (limits && boxes[currentRow][currentColumn] != null && boxes[currentRow][currentColumn].getColorPiece() != null && !Objects.equals(boxes[currentRow][currentColumn].getColorPiece(), getColor())) {
                            total++;
                        }
                    }
                    if(total>max){
                        max=total;
                        cRow=i;
                        cCol=j;
                    }
                    total=0;
                }
            }
        }
        String typePiece=getPiece();
        generatePiece(cRow, cCol, typePiece);
        return false;
    }

    private String getPiece(){
        if(numberStones[0]>0){
            return "normal";
        } else if (numberStones[1]>0) {
            return "heavy";
        }
        else{
            return "temporary";
        }
    }
}
