use std::collections::HashSet;

fn is_valid_id(id: i128) -> bool {
    let mut x = id;
    let mut digits = [0usize; 50];
    let mut num_digits = 0;
    while x > 0 {
        digits[num_digits] = (x % 10) as usize;
        x /= 10;
        num_digits += 1;
    }

    if num_digits % 2 != 0 {
        return true
    }

    for pos in 0..(num_digits / 2) {
        let i = num_digits - 1 - pos;
        let j = i - (num_digits / 2);
        if digits[i] != digits[j] {
            return true
        }
    }

    false
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
