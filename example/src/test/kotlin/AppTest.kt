import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class AppTest {
    @Test
    fun twoTimesTwo() {
        assertEquals(4, mul(2, 2))
    }

    @Test
    fun twoTimesThree() {
        assertEquals(6, mul(2, 3))
    }

    @Test
    fun threeTimesThree() {
        assertEquals(9, mul(3, 3))
    }
}
