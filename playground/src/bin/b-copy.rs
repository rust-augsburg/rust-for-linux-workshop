fn take_and_return(value: u8) -> u8 {
    println!("value '{value}' passed");
    value
}

fn take(value: u8) {
    println!("value '{value}' passed");
}

fn main() {
    let value = 1;
    print!("{value}");
}
