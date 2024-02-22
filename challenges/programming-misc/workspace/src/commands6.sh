touch app.py
echo "import math" >> app.py
echo "def square_root(n):" >> app.py
echo "  return math.sqrt(n)" >> app.py
touch test.py
echo "from app import square_root" >> test.py
echo "def test_square_root():" >> test.py
echo "  assert square_root(4) == 2.0" >> test.py
git add .
git commit -m "Initial code"
touch docs.md
echo "## Description" >> docs.md
echo "This app provides a simple math function to find square root." >> docs.md
echo "## Usage" >> docs.md
echo "python" >> docs.md
echo "from app import square_root" >> docs.md
echo "print(square_root(9))" >> docs.md
echo "" >> docs.md
git add .
git commit -m "Add documentation"
gh pr create -t "Initial code and documentation"


gh pr checkout
gh pr merge
git pull origin main
touch CONTRIBUTING.md
echo "# Contributing Guidelines" >> CONTRIBUTING.md
git add .
git commit -m "Add contributing guidelines"
gh pr create -t "Add contributing guidelines"


gh pr checkout
gh pr merge
git pull origin main
echo "def factorial(n):" >> app.py
echo "  if n == 0:" >> app.py
echo "    return 1" >> app.py
echo "  else:" >> app.py
echo "    return n * factorial(n-1)" >> app.py
echo "def test_factorial():" >> test.py
echo "  assert factorial(5) == 120" >> test.py
git add .
git commit -m "Add factorial function and test"
gh pr create -t "Add factorial function and test"


gh pr checkout
gh pr merge
git pull origin main
echo "## Factorial function" >> docs.md
echo "python" >> docs.md
echo "from app import factorial" >> docs.md
echo "print(factorial(5))" >> docs.md
echo "" >> docs.md
git add .
git commit -m "Update documentation"
gh pr create -t "Update documentation"


gh pr checkout
gh pr merge
git pull origin main
echo "def test_factorial_zero():" >> test.py
echo "  assert factorial(0) == 1" >> test.py
gp add .
gp commit -m "Add test for factorial zero"
gh pr create -t "Add test for factorial zero"


gh pr checkout
gh pr merge
git pull origin main
echo "import pytest" >> test.py
echo "def main():" >> test.py
echo "  pytest.main()" >> test.py
echo "if __name__ == '__main__':" >> test.py
echo "  main()" >> test.py
git add .
git commit -m "Automate testing"
gh pr create -t "Automate testing"


gh pr checkout
gh pr merge
git pull origin main
touch .gitignore
echo "__pycache__/" >> .gitignore
echo "*.pyc" >> .gitignore
git add .
gp commit -m "Add gitignore"
gh pr create -t "Add gitignore"


gh pr checkout
gh pr merge
git pull origin main
echo "def factorial(n):" >> app.py
echo "  return 1 if n == 0 else n * factorial(n-1)" >> app.py
git add .
git commit -m "Improve code style"
gh pr create -t "Improve code style"


gh pr checkout
gh pr merge
git pull origin main
mv app.py sqrt_app.py
mv test.py sqrt_test.py
git add .
git commit -m "Refactor code"
gh pr create -t "Refactor code"


gh pr checkout
gh pr merge
git pull origin main
echo "def factorial(n, acc=1):" >> app.py
echo "  return acc if n <= 1 else factorial(n-1, n*acc)" >> app.py
git add .
git commit -m "Optimize factorial function"
gh pr create -t "Optimize factorial function"


gh pr checkout
gh pr merge
git pull origin main
git add .
git commit -m "Add gitattributes"
gh pr create -t "Add gitattributes"


gh pr checkout
gh pr merge
git pull origin main
rm docs.md
mv CONTRIBUTING.md README.md
git add .
git commit -m "Cleanup repository"
gh pr create -t "Cleanup repository"


gh pr checkout
gh pr merge
git pull origin main
echo "# Test Workflow" >> README.md
git add .
git commit -m "Finalize README"
gh pr create -t "Finalize README"


gh pr checkout
gh pr merge
git pull origin main

echo "def add_numbers(a, b):" >> main.py
echo "    return a + b" >> main.py
echo "def subtract_numbers(a, b):" >> main.py
echo "    return a - b" >> main.py
echo "def multiply_numbers(a, b):" >> main.py
echo "    return a * b" >> main.py
echo "def divide_numbers(a, b):" >> main.py
echo "    if b != 0:" >> main.py
echo "        return a / b" >> main.py
echo "    else:" >> main.py
echo "        raise ValueError('Cannot divide by zero.')" >> main.py
git add main.py
git commit -m "Create main.py with basic arithmetic functions"
git push origin main
echo "import unittest" >> test_main.py
echo "from main import add_numbers, subtract_numbers, multiply_numbers, divide_numbers" >> test_main.py
echo "class TestMain(unittest.TestCase):" >> test_main.py
echo "    def test_add_numbers(self):" >> test_main.py
echo "        self.assertEqual(add_numbers(1, 2), 3)" >> test_main.py
echo "    def test_subtract_numbers(self):" >> test_main.py
echo "        self.assertEqual(subtract_numbers(5, 2), 3)" >> test_main.py
echo "    def test_multiply_numbers(self):" >> test_main.py
echo "        self.assertEqual(multiply_numbers(2, 3), 6)" >> test_main.py
echo "    def test_divide_numbers(self):" >> test_main.py
echo "        self.assertEqual(divide_numbers(6, 2), 3)" >> test_main.py
echo "    def test_divide_by_zero_error(self):" >> test_main.py
echo "        with self.assertRaises(ValueError):" >> test_main.py
echo "            divide_numbers(1, 0)" >> test_main.py
git add test_main.py
git commit -m "Create unit tests for the arithmetic functions"
git push origin main
echo "# Python Functions Test Application" > README.md
echo "This application includes several basic arithmetic functions and their unit tests." >> README.md
echo "## Usage" >> README.md
echo "To use the application, import the functions from main.py in your python code." >> README.md
echo "For example:" >> README.md
echo "## Running Tests" >> README.md
echo "To run the tests, execute test_main.py with python's unittest module." >> README.md
echo "For example:" >> README.md
git commit -m "Create README file"
git push origin main
echo "import sys" >> main.py
echo "if __name__ == '__main__':" >> main.py
echo "    a = int(sys.argv[1])" >> main.py
echo "    b = int(sys.argv[2])" >> main.py
echo "    print('Add:', add_numbers(a, b))" >> main.py
echo "    print('Subtract:', subtract_numbers(a, b))" >> main.py
echo "    print('Multiply:', multiply_numbers(a, b))" >> main.py
echo "    print('Divide:', divide_numbers(a, b))" >> main.py
git add main.py
git commit -m "Add command line interface"
git push origin main
python -m unittest test_main
gh pr create -t "Add basic arithmetic functions" -b "This PR adds the following basic arithmetic functions: add_numbers, subtract_numbers, multiply_numbers, divide_numbers. Please review and merge."
echo "def square_number(a):" >> main.py
echo "    return a**2" >> main.py
git add main.py
git commit -m "Create square_number function"
git push origin main
echo "    def test_square_number(self):" >> test_main.py
echo "        self.assertEqual(square_number(3), 9)" >> test_main.py
git add test_main.py
git commit -m "Create unit test for the square_number function"
git push origin main
gh pr create -t "Add square_number function" -b "This PR adds the square_number function allows square two numbers. Please review and merge."
echo "print('Square:', square_number(a))" >> main.py
git add main.py
git commit -m "Add square number to command line interface"
git push origin main
