fun main() {
    // Test calling a function declared in a separate module.
    println("""${helloString()}, World!""")

    // Test string split.
    "this,is,a,test".split(",").forEach { it -> println("Piece: '${it}'") }
}
