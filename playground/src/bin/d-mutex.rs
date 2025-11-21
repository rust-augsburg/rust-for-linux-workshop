use std::{
    sync::{Arc, Mutex},
    time::Duration,
};

fn main() {
    let data = String::from("test");
    let data = Arc::new(data);

    {
        let data = data.clone();
        std::thread::spawn(move || {
            for i in 0..3 {
                // *data = i.to_string();
                println!("{data}");
                std::thread::sleep(Duration::from_secs(2));
            }
        });
    }

    std::thread::spawn(move || {
        loop {
            println!("{data}");
            std::thread::sleep(Duration::from_secs(1));
        }
    });
}
