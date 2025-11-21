fn take_and_return(name: String) -> String {
    println!("name '{name}' was moved, but will be returned");
    name
}

fn take(name: String) {
    println!("name '{name}' was moved");
}

fn main() {
    let michael = "Michael".to_owned();
    print!("{michael}");
}
