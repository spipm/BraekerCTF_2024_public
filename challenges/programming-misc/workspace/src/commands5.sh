echo "def addition(a, b):" > application.py
echo "    return a + b" >> application.py
echo "def subtraction(a, b):" >> application.py
echo "    return a - b" >> application.py
echo "def multiplication(a, b):" >> application.py
echo "    return a * b" >> application.py
echo "def division(a, b):" >> application.py
echo "    if b != 0:" >> application.py
echo "        return a / b" >> application.py
echo "    else:" >> application.py
echo "        return 'Cannot divide by zero'" >> application.py

git add application.py
git commit -m "Add the application.py file"

echo "import unittest" > test_application.py
echo "import application" >> test_application.py
echo "class TestApplication(unittest.TestCase):" >> test_application.py
echo "    def test_addition(self):" >> test_application.py
echo "        self.assertEqual(application.addition(5, 3), 8)" >> test_application.py
echo "    def test_subtraction(self):" >> test_application.py
echo "        self.assertEqual(application.subtraction(5, 3), 2)" >> test_application.py
echo "    def test_multiplication(self):" >> test_application.py
echo "        self.assertEqual(application.multiplication(5, 3), 15)" >> test_application.py
echo "    def test_division(self):" >> test_application.py
echo "        self.assertEqual(application.division(6, 3), 2)" >> test_application.py
echo "        self.assertEqual(application.division(5, 0), 'Cannot divide by zero')" >> test_application.py

git add test_application.py
git commit -m "Add the test_application.py file"

echo "import application" > run.py
echo "print('Addition of 2 and 3 is', application.addition(2, 3))" >> run.py
echo "print('Subtraction of 5 from 8 is', application.subtraction(8, 5))" >> run.py
echo "print('Multiplication of 7 and 4 is', application.multiplication(7, 4))" >> run.py
echo "print('Division of 14 by 7 is:', application.division(14, 7))" >> run.py
echo "print('Division of 5 by 0 is:', application.division(5, 0))" >> run.py

git add run.py
git commit -m "Add the run.py file"
