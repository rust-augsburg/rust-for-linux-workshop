#[derive(Debug)]
enum State {
    Unitialized,
    Unverified,
    Ready,
}

impl State {
    fn new() -> Self {
        Self::Unitialized
    }

    fn init(&mut self, data: u64) {
        *self = Self::Unverified;
    }

    fn verify(&mut self) -> Result<(), String> {
        todo!()
    }

    fn extract_verified(self) -> Option<()> {
        todo!()
    }
}

fn main() {
    let test = State::new();
}
