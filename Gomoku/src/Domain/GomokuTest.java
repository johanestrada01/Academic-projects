package Domain;

import Domain.Funky;
import Domain.Gomoku;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class GomokuTest {

    @Test
    void testGomokuInitialization() {
        Gomoku gomoku = new Gomoku(15, "Player1", "Player2", "normal", "Humano", false);
        assertNotNull(gomoku);
    }

    @Test
    void testHumanPlayerInitialization() {
        Gomoku gomoku = new Gomoku(15, "Player1", "Player2", "normal", "Humano", false);
        assertNotNull(gomoku.player1);
        assertEquals("Player1", gomoku.player1.getName());
        assertEquals("white", gomoku.player1.getColor());
        assertEquals(15, gomoku.getBoardSize());
    }

    @Test
    void testFunkyPlayerInitialization() {
        Gomoku gomoku = new Gomoku(15, "Player1", "Player2", "normal", "Maquina miedosa", false);
        assertNotNull(gomoku.player2);
        assertEquals("Player2", gomoku.player2.getName());
        assertEquals("black", gomoku.player2.getColor());
        assertEquals(15, gomoku.getBoardSize());
        assertTrue(gomoku.player2 instanceof Funky);
    }

    @Test
    void testActionPlay() {
        Gomoku gomoku = new Gomoku(15, "Player1", "Player2", "normal", "Humano", false);
        int[] positions = {0, 0};
        assertDoesNotThrow(() -> gomoku.actionPlay(positions, "normal"));
    }

    @Test
    void testFind() {
        Gomoku gomoku = new Gomoku(15, "Player1", "Player2", "normal", "Humano", false);
        assertFalse(gomoku.find(0, 0));
    }

}
