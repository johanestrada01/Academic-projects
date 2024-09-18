package Domain;

import java.io.Serializable;
import java.util.*;

public class Funky extends Machine implements Serializable{
    public Funky(int percentage, String name, String color, int size) {
        super(percentage, name, color, size);
    }

    public Funky(String name, String color, int size, int numberStones) {
        super(name, color, size, numberStones);
    }

    @Override
    public boolean play(String type) throws GomokuException {
        int[] positions = find();
        ArrayList<Integer> indexes=new ArrayList<Integer>();
        for(int i=0; i<numberStones.length; i++){
            if(numberStones[i]>0){
                indexes.add(i);
            }
        }
        Random random=new Random();
        int index=random.nextInt(indexes.size());
        index=indexes.get(index);
        String piece;
        if(index==0){
            piece="normal";
        }
        else if(index==1){
            piece="heavy";
        }
        else{
            piece="temporary";
        }
        generatePiece(positions[0], positions[1], piece);
        return Board.getBoard().find(positions[0], positions[1]);
    }

    private int[] find() {
        Board board = Board.getBoard();
        ArrayList<int[]> stones = new ArrayList<int[]>();
        Box[][] boxes = board.getBoxes();
        for (int i = 0; i < boxes.length; i++) {
            for (int j = 0; j < boxes.length; j++) {
                if (boxes[i][j] != null && boxes[i][j].getColorPiece() != null && boxes[i][j].getColorPiece() != getColor()) {
                    stones.add(new int[]{i, j});
                }
            }
        }
        return bestDistance(stones);
    }

    private int[] bestDistance(ArrayList<int[]> data) {
        int[] x = new int[]{0, 1, 1, 1, 0, -1, -1, -1};
        int[] y = new int[]{-1, -1, 0, 1, 1, 1, 0, -1};
        Set<int[]> stones = new HashSet<>(data);
        Box[][] boxes = Board.getBoard().getBoxes();
        int size = boxes.length;
        Queue<int[]> queue = new LinkedList<>(stones);
        int[] current = new int[]{0, 0};
        while (!queue.isEmpty()) {
            int[] value = queue.poll();
            int row = value[0];
            int column = value[1];
            for (int j = 0; j < x.length; j++) {
                int newColumn = column + x[j];
                int newRow = row + y[j];
                int[] array = {newRow, newColumn};
                if (newColumn >= 0 && newRow >= 0 && newColumn < size && newRow < size && !contains(stones, array)) {
                    if (boxes[newRow][newColumn] == null || boxes[newRow][newColumn].getColorPiece() == null) {
                        queue.offer(array);
                        stones.add(array);
                        current = array;
                    }
                }
            }
        }
        return current;
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

