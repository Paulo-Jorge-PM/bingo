use gdnative::prelude::*;
use rand::{distributions::Uniform, Rng};

#[derive(NativeClass)]
#[inherit(Node)]

#[register_with(Self::register_builder)]
pub struct HelloWorld {
    #[property]
    time: f32,
    teste: Vec<i32>,
}

#[methods]
impl HelloWorld {

    fn register_builder(_builder: &ClassBuilder<Self>) {
        godot_print!("GDNative game builder is registered!");
    }

    fn new(_owner: &Node) -> Self {
        godot_print!("GDNative initialization is registered!");
        HelloWorld {
            time: 5.0,
            teste: vec![3,4],
        }
    }


    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("Hello world from Rust GDNative ready function!");
    }


    #[export]
    fn generateNumbers(&self, _owner: &Node, totalBalls:u32, rangeNumbers:u32) -> Vec<u32> {

        let mut range: Vec<u32> = (0..60).map(|v| v + 1).collect();
        let mut numbers: Vec<u32> = Vec::new();

        for i in 0..30 {
            let index = (rand::random::<f32>() * range.len() as f32).floor() as usize;
            let value = range.remove( index );
            numbers.push(value)
        }

        numbers.sort();
        
        /*let mut rng = rand::thread_rng();
        let range = Uniform::new(0, 30);
        let vals: Vec<u64> = (0..30).map(|_| rng.sample(&range)).collect();
        godot_print!("{:?}", vals);
        let numbers = vec![5,6];*/
        godot_print!("Random balls numers: {:?}", numbers);
        return numbers;
    }  
}

fn init(handle: InitHandle) {
    handle.add_class::<HelloWorld>();
}

godot_init!(init);