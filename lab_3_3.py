def extended_euclidean_algorithm(m, n):
    # Начальные значения: a=1, b=0, x0=0, x1=1, y0=m, y1=n
    a, b, x0, x1, y0, y1 = 1, 0, 0, 1, m, n

    while y1 != 0:
        quotient = y0 // y1  # Находим частное от деления y0 на y1
        # Обновляем значения a, b, x0, x1, y0, y1 в соответствии с алгоритмом
        a, b = b, a - quotient * b
        x0, x1 = x1, x0 - quotient * x1
        y0, y1 = y1, y0 - quotient * y1

    return a, b, y0

m = int(input("Введите число m:"))
n = int(input("Введите число n:"))

if m < n:
    print("m больше n, поэтому меняем местами")
    m, n = n, m

a, b, gcd = extended_euclidean_algorithm(m, n)

print(f"Целые числа, удовлетворяющие соотношению Безу для m={m} и n={n}:")
print(f"a: {a}, b: {b}")
print(f"НОД({m}, {n}): {gcd}")


