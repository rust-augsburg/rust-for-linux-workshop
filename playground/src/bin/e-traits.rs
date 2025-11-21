trait Printable {
    fn print(&self) -> String;
}

struct Test;

// impl Printable for Test {
// }

fn main() {
    let test = Test;
    // println!("{}", test.print());
}
