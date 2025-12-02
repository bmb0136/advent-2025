fn is_valid_id(id: i128) -> bool {
    let mut x = id;
    let mut digits = [0usize; 50];
    let mut num_digits = 0;
    while x > 0 {
        digits[num_digits] = (x % 10) as usize;
        x /= 10;
        num_digits += 1;
    }

    for pattern_size in (1..num_digits).rev() {
        if num_digits % pattern_size != 0 {
            continue;
        }
        let mut is_valid = true;
        'outer: for pos in 0..pattern_size {
            let d = digits[num_digits - 1 - pos];
            for repeat_index in 0..(num_digits / pattern_size) {
                if d != digits[num_digits - 1 - pos - (repeat_index * pattern_size)] {
                    is_valid = false;
                    break 'outer;
                }
            }
        }

        if is_valid {
            return false
        }
    }

    true
}

fn main() {
    let answer = include_str!("./input.txt")
        .split("\n")
        .filter(|l| l.len() > 0)
        .flat_map(|l| l.split(","))
        .flat_map(|p| {
            let ids: Vec<_> = p
                .split('-')
                .map(|s| s.parse::<i128>().expect(&format!("ID {} was not an integer", s)))
                .collect();

            assert!(ids.len() == 2);

            (ids[0])..=(ids[1])
        })
        .filter(|id| !is_valid_id(*id))
        .sum::<i128>();

    println!("Answer: {}", answer);
}
