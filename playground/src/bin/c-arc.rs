// use std::sync::Arc;

fn main() {
    let data = String::from("test");

    std::thread::spawn(move || {
        println!("{data}");
    });

    std::thread::spawn(move || {
        // println!("{data}");
    });
}
