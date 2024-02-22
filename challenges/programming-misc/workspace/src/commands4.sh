cd source_code

echo "def complex_function(x, y):
    result = (x**2 + y**2)**0.5
    return result" > complex_calc.py

git checkout -b feature/complex_calc

git add complex_calc.py

git commit -m "Add complex calculation functionality"

echo "def test_complex_function():
    assert complex_function(3, 4) == 5
    assert complex_function(0, 0) == 0
    assert complex_function(-3, -4) == 5" > test_complex_calc.py

git add test_complex_calc.py

git commit -m "Add tests for complex calculation"

git checkout master

git merge feature/complex_calc

gh pr create --title "Add complex calculation and tests" --body "This PR adds a more complex calculation function and tests for it."

gh pr merge --auto --merge

git branch -d feature/complex_calc

echo "def very_complex_function(x, y, z):
    result = (x**3 + y**3 + z**3)**(1/3)
    return result" > very_complex_calc.py

git checkout -b feature/very_complex_calc

git add very_complex_calc.py

git commit -m "Add very complex calculation functionality"

echo "def test_very_complex_function():
    assert very_complex_function(1, 1, 1) == 3**(1/3)
    assert very_complex_function(0, 0, 0) == 0
    assert very_complex_function(-1, -1, -1) == -3**(1/3)" > test_very_complex_calc.py

git add test_very_complex_calc.py

git commit -m "Add tests for very complex calculation"

git checkout master

git merge feature/very_complex_calc

gh pr create --title "Add very complex calculation and tests" --body "This PR adds a more complex calculation function and tests for it."

gh pr merge --auto --merge

git branch -d feature/very_complex_calc

echo "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFvS1Ayakhyb3p4Z1daRHExR3pMSAoxVHd6QU5NMUc0Q0JicE9IZHpNYXlKaU84YXY0bitXSVpTWXdJVis0ZXhiNkozTVNkOEhheTNMdDlVcXdRaHpiCkQrdEIwYWRNY3piM0w4MVV0VDFRaCtvK1ZDcU1mSzBCZGd0R0dIU3FuaTVUQmtLTkF1alpHTkdtRUJ2UmRhRncKdkEyTkRwS05mSm5MVDd0L2wwYlY3RTFHa3NDMk9weVRnUnIya1RmcGswWnhuZmZ0anJLK3VxS1MrU08rOUFXNgp5YkZsVkxINVVSNzZaVWZ6ZDl4QzhPYUpnRWVPZlJoLzZKWUxHaGhZaGF1K1F6TlV2OHYzSUxRZjJ4ZFVFZ3ZnCk5mMUViOVA4RllqSFJvVEJOSzYwRzNodkNhYnJjTmlTaFZKYzdjbUFQSmhCTzNNUStkamtMc1ZySVQ1bjZOK04KVndJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg==" > .pub_key

git add .pub_key

git commit -m "Add complex function"

git checkout -b feature/add_complex

rm .pub_key

git rm --cached .pub_key

git commit -m "Remove complex addition"

git checkout master

git merge feature/add_complex

gh pr create --title "Complex edit" --body "This PR removes or adds the complex function."

gh pr merge --auto --merge

git branch -d feature/add_complex
