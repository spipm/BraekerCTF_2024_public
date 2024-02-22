#!/bin/bash

echo 'def add(x, y):' > app.py
echo '    """Add Function"""' >> app.py
echo '    return x + y' >> app.py
echo 'def subtract(x, y):' >> app.py
echo '    """Subtract Function"""' >> app.py
echo '    return x - y' >> app.py
git checkout -b feature/multiply
echo 'def multiply(x, y):' >> app.py
echo '    """Multiply Function"""' >> app.py
echo '    return x * y' >> app.py
git add .
git commit -m "Add multiply function"
git checkout master
git checkout -b feature/divide
echo 'def divide(x, y):' >> app.py
echo '    """Divide Function"""' >> app.py
echo '    if y != 0:' >> app.py
echo '        return x / y' >> app.py
echo '    else:' >> app.py
echo '        return "Error, division by zero."' >> app.py
git add .
git commit -m "Add divide function"
git checkout master
git merge feature/multiply --no-ff -m "Merge multiply function"
git merge feature/divide --no-ff -m "Merge divide function"
mkdir tests
cd tests
echo 'import unittest' > test_app.py
echo 'from source_code.app import add, subtract, multiply, divide' >> test_app.py
echo 'class TestApp(unittest.TestCase):' >> test_app.py
echo '    def test_add(self):' >> test_app.py
echo '        result = add(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 15)' >> test_app.py
echo '    def test_subtract(self):' >> test_app.py
echo '        result = subtract(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 5)' >> test_app.py
echo '    def test_multiply(self):' >> test_app.py
echo '        result = multiply(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 50)' >> test_app.py
echo '    def test_divide(self):' >> test_app.py
echo '        result = divide(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 2)' >> test_app.py
git add .
git commit -m "Add tests for app.py"
cd ..
mkdir docs
echo '# Application documentation' > docs/readme.md
echo 'This is a simple application to test python functions. It includes functions for adding, subtracting, multiplying, and dividing.' >> docs/readme.md
git add .
git commit -m "Add initial documentation"
gh pr create --title "Initial code and tests" --body "This PR includes initial code and tests" 
gh pr merge --merge_COMMIT_SHA --merge
cd source_code
touch main.py
echo "def add(a, b): return a+b" >> main.py
git branch feature/add-function
git checkout feature/add-function
echo "def subtract(a, b): return a-b" >> main.py
git add main.py
git commit -m "Added subtract function"
git push origin feature/add-function
git checkout main
git merge feature/add-function
git branch feature/multiply-function
git checkout feature/multiply-function
echo "def multiply(a, b): return a*b" >> main.py
git add main.py
git commit -m "Added multiply function"
git push origin feature/multiply-function
git checkout main
git merge feature/multiply-function
cd ..
mkdir tests
cd tests
touch test_main.py
echo "import unittest" >> test_main.py
echo "from source_code.main import add, subtract, multiply" >> test_main.py
echo "class TestMain(unittest.TestCase): def test_add(self): self.assertEqual(add(5, 7), 12)" >> test_main.py
echo "def test_subtract(self): self.assertEqual(subtract(10, 5), 5)" >> test_main.py
echo "def test_multiply(self): self.assertEqual(multiply(3, 7), 21)" >> test_main.py
echo "if __name__ == '__main__': unittest.main()" >> test_main.py
cd ..
git add tests/test_main.py
git commit -m "Added unit tests"
git push origin main
mkdir docs
touch docs/index.md
echo "# Python Functions Test App Documentation" >> docs/index.md
echo "This application is designed to test various Python functions." >> docs/index.md
	git add docs/index.md
git commit -m "Added documentation"
git push origin main
cd source_code
echo "def add_nums(num1, num2):" > math_funcs.py
echo "    return num1 + num2" >> math_funcs.py
git branch new-feature
git checkout new-feature
echo "Def subtract_nums(num1, num2):" > math_funcs.py
echo "    return num1 - num2" >> math_funcs.py
echo "def multiply_nums(num1, num2):" > math_funcs.py
echo "    return num1 * num2" >> math_funcs.py
git add math_funcs.py
git commit -m "Added new math functions"
git checkout main
git merge new-feature
gh pr create --base main --head new-feature --title "New Feature" --body "Added new math functions"
gh pr view
gh pr merge --merge
cd ..
mkdir tests
cd tests
echo "import unittest" > test_math_funcs.py
echo "from source_code import math_funcs" >> test_math_funcs.py
echo "class TestMathFuncs(unittest.TestCase):" >> test_math_funcs.py
echo "def test_add(self):" >> test_math_funcs.py
echo "def test_subtract(self):" >> test_math_funcs.py
echo "def test_multiply(self):" >> test_math_funcs.py
git add test_math_funcs.py
git commit -m "Added unit tests for math functions"
git push origin main
cd ..
mkdir docs
echo "This application provides math functions" > docs/readme.md
echo "The functions include addition, subtraction, and multiplication" >> docs/readme.md
git add docs/readme.md
git commit -m "Added documentation for the application"
git push origin main
echo 'def add(x, y):' > app.py
echo '    """Add Function"""' >> app.py
echo '    return x + y' >> app.py
echo 'def subtract(x, y):' >> app.py
echo '    """Subtract Function"""' >> app.py
echo '    return x - y' >> app.py
git checkout -b feature/multiply
echo 'def multiply(x, y):' >> app.py
echo '    """Multiply Function"""' >> app.py
echo '    return x * y' >> app.py
git add .
git commit -m "Add multiply function"
git checkout master
git checkout -b feature/divide
echo 'def divide(x, y):' >> app.py
echo '    """Divide Function"""' >> app.py
echo '    if y != 0:' >> app.py
echo '        return x / y' >> app.py
echo '    else:' >> app.py
echo '        return "Error, division by zero."' >> app.py
git add .
git commit -m "Add divide function"
git checkout master
git merge feature/multiply --no-ff -m "Merge multiply function"
git merge feature/divide --no-ff -m "Merge divide function"
mkdir tests
cd tests
echo 'import unittest' > test_app.py
echo 'from source_code.app import add, subtract, multiply, divide' >> test_app.py
echo 'class TestApp(unittest.TestCase):' >> test_app.py
echo '    def test_add(self):' >> test_app.py
echo '        result = add(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 15)' >> test_app.py
echo '    def test_subtract(self):' >> test_app.py
echo '        result = subtract(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 5)' >> test_app.py
echo '    def test_multiply(self):' >> test_app.py
echo '        result = multiply(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 50)' >> test_app.py
echo '    def test_divide(self):' >> test_app.py
echo '        result = divide(10, 5)' >> test_app.py
echo '        self.assertEqual(result, 2)' >> test_app.py
git add .
git commit -m "Add tests for app.py"
cd ..
mkdir docs
echo '# Application documentation' > docs/readme.md
echo 'This is a simple application to test python functions. It includes functions for adding, subtracting, multiplying, and dividing.' >> docs/readme.md
git add .
git commit -m "Add initial documentation"
gh pr create --title "Initial code and tests" --body "This PR includes initial code and tests" 

