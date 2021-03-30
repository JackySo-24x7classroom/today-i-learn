# Create Tables in Python programming - introduce and taste tabulate
---
Present data into table format in Python

## Table of Content
---
* [Construct table in various ways](#Construct-table-in-various-ways)
* [Use tabulate to present and format table output](#Use-tabulate-to-present-and-format-table-output)
  * [Installation](#Installation)
  * [Usage](#Usage)
  * [Example](#Example)
  * [Useful tricks](#Useful-tricks)
    * [Use pipe character as tableformat to fit for native Markdown table style](#Use-pipe-character-as-tableformat-to-fit-for-native-Markdown-table-style)
    * [Use plain as tableformat for simple](#Use-plain-as-tableformat-for-simple)

## Construct table in various ways

```python
#!/usr/bin/env python3
print ("## Python program to print the data")
ssl_1 = [["example.com","443","sit-example.com"],["abc.org","443","test.abc.org"],["24x7classroom.edu","443","t24x7classroom.edu"]]
ssl_2 = {1: ["example.com","443","sit-example.com"], 2: ["abc.org","443","test.abc.org"], 3: ["24x7classroom.edu","443","t24x7classroom.edu"]}
ssl_3 = [[1,"Production domain","SSL port","Uat domain"], [2,"example.com","443","sit-example.com"], [3,"abc.org","443","test.abc.org"], ["24x7classroom.edu","443"]]

## Python program to print the data
print ("{:<8} {:<15} {:<10} {:<10}".format('Pos','Domain','Port','Uat'))
for k, v in ssl_2.items():
    do, po, ua = v
    print ("{:<8} {:<15} {:<10} {:<10}".format(k, do, po, ua))

## By utilizing the Format Function
print ("## By utilizing the Format Function")
dota_teams = ["Domain", "Port", "Uat"]
format_row = "{:>12}" * (len(dota_teams) + 1)
print(format_row.format("", *dota_teams))
for team, row in zip(dota_teams, ssl_1):
    print(format_row.format(team, *row))

## Python program to understand the usage of tabulate function for printing tables in a tabular format
print ("## Python program to understand the usage of tabulate function for printing tables in a tabular format")
from tabulate import tabulate
print (tabulate(ssl_1, headers=["Production domain", "SSL port", "Uat domain"]))

## Python program to understand, how to print tables using pandas data frame
print ("## Python program to understand, how to print tables using pandas data frame")
import pandas
headers=["Pos", "Domain", "Port", "Uat"]
print('                                         ')
print('-----------------------------------------')
print('                                         ')
print(pandas.DataFrame(ssl_3, headers, headers))
```

## Use tabulate to present and format table output

### Installation
```bash
$ pip install -U tabulate
```

### Usage
```python
from tabulate import tabulate
data = [['a',1],['b',2]]
print(tabulate(data)
```

### Example
```python
$  make ipython
Python 3.8.5 (default, Jan 27 2021, 15:41:15) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.21.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: from tabulate import tabulate

In [2]: [["Production domain","SSL port","Uat domain"],["example.com","443","sit-example.com"],["abc.org","443","test.abc.org"],["24x7classroom.edu","443"]]
Out[2]: 
[['Production domain', 'SSL port', 'Uat domain'],
 ['example.com', '443', 'sit-example.com'],
 ['abc.org', '443', 'test.abc.org'],
 ['24x7classroom.edu', '443']]

In [3]: ssl = [["Production domain","SSL port","Uat domain"],["example.com","443","sit-example.com"],["abc.org","443","test.abc.org"],["24x7classroom.edu","443"]]

In [4]: print(tabulate(ssl))
---------------------  --------  ------------------------------
Production domain      SSL port  Uat domain
example.com            443       sit-example.com
abc.org                443       test.abc.org
24x7classroom.edu      443
---------------------  --------  ------------------------------

In [5]: print(tabulate(ssl,headers='firstrow'))
Production domain        SSL port  Uat domain
---------------------  ----------  ------------------------------
example.com            443         sit-example.com
abc.org                443         test.abc.org
24x7classroom.edu      443

In [6]: print(tabulate(ssl,headers='firstrow',tablefmt='fancy_grid'))
╒═══════════════════════╤════════════╤════════════════════════════════╕
│ Production domain     │   SSL port │ Uat domain                     │
╞═══════════════════════╪════════════╪════════════════════════════════╡
│ example.com           │        443 │ sit-example.com                │
├───────────────────────┼────────────┼────────────────────────────────┤
│ abc.org               │        443 │ test.abc.org                   │
├───────────────────────┼────────────┼────────────────────────────────┤
│ 24x7classroom.edu     │        443 │                                │
╘═══════════════════════╧════════════╧════════════════════════════════╛

In [7]: print(tabulate(ssl,headers='firstrow',tablefmt='fancy_grid',missingval='n/a'))
╒═══════════════════════╤════════════╤════════════════════════════════╕
│ Production domain     │   SSL port │ Uat domain                     │
╞═══════════════════════╪════════════╪════════════════════════════════╡
│ example.com           │        443 │ sit-example.com                │
├───────────────────────┼────────────┼────────────────────────────────┤
│ abc.org               │        443 │ test.abc.org                   │
├───────────────────────┼────────────┼────────────────────────────────┤
│ 24x7classroom.edu     │        443 │ n/a                            │
╘═══════════════════════╧════════════╧════════════════════════════════╛

In [8]: print(tabulate(ssl,headers='firstrow',tablefmt='fancy_grid',missingval='n/a',showindex=True))
╒════╤═══════════════════════╤════════════╤════════════════════════════════╕
│    │ Production domain     │   SSL port │ Uat domain                     │
╞════╪═══════════════════════╪════════════╪════════════════════════════════╡
│  0 │ example.com           │        443 │ sit-example.com                │
├────┼───────────────────────┼────────────┼────────────────────────────────┤
│  1 │ abc.org               │        443 │ test.abc.org                   │
├────┼───────────────────────┼────────────┼────────────────────────────────┤
│  2 │ 24x7classroom.edu     │        443 │ n/a                            │
╘════╧═══════════════════════╧════════════╧════════════════════════════════╛

In [9]: print(tabulate(ssl,headers='firstrow',tablefmt='fancy_grid',missingval='n/a',showindex=range(1,len(ssl))))
╒════╤═══════════════════════╤════════════╤════════════════════════════════╕
│    │ Production domain     │   SSL port │ Uat domain                     │
╞════╪═══════════════════════╪════════════╪════════════════════════════════╡
│  1 │ example.com           │        443 │ sit-example.com                │
├────┼───────────────────────┼────────────┼────────────────────────────────┤
│  2 │ abc.org               │        443 │ test.abc.org                   │
├────┼───────────────────────┼────────────┼────────────────────────────────┤
│  3 │ 24x7classroom.edu     │        443 │ n/a                            │
╘════╧═══════════════════════╧════════════╧════════════════════════════════╛


In [11]: ssl = {'Bankfeeds services': ["T4 Example", "T5 abc", "T6 24x7"], 'Production domain': ["example.com", "abc.org", "24x7classroom.edu"], 'SSL port': [443], 'Uat domain': ["sit-example.com","test.abc.org","t24x7classroom.edu"]}


In [12]: print(tabulate(ssl,headers='keys',tablefmt='fancy_grid',missingval='443',showindex=True))
╒════╤══════════════════════╤═══════════════════════╤════════════╤════════════════════════════════╕
│    │ Bankfeeds services   │ Production domain     │   SSL port │ Uat domain                     │
╞════╪══════════════════════╪═══════════════════════╪════════════╪════════════════════════════════╡
│  0 │ T4 Example           │ example.com           │        443 │ sit-example.com                │
├────┼──────────────────────┼───────────────────────┼────────────┼────────────────────────────────┤
│  1 │ T5 abc               │ abc.org               │        443 │ test.abc.org                   │
├────┼──────────────────────┼───────────────────────┼────────────┼────────────────────────────────┤
│  2 │ T6 24x7              │ 24x7classroom.edu     │        443 │ t24x7classroom.edu             │
╘════╧══════════════════════╧═══════════════════════╧════════════╧════════════════════════════════╛

In [13]: print(tabulate(ssl,headers='keys',tablefmt='fancy_grid',missingval='443',showindex=range(1,len(ssl))))
╒════╤══════════════════════╤═══════════════════════╤════════════╤════════════════════════════════╕
│    │ Bankfeeds services   │ Production domain     │   SSL port │ Uat domain                     │
╞════╪══════════════════════╪═══════════════════════╪════════════╪════════════════════════════════╡
│  1 │ T4 Example           │ example.com           │        443 │ sit-example.com                │
├────┼──────────────────────┼───────────────────────┼────────────┼────────────────────────────────┤
│  2 │ T5 abc               │ abc.org               │        443 │ test.abc.org                   │
├────┼──────────────────────┼───────────────────────┼────────────┼────────────────────────────────┤
│  3 │ T6 24x7              │ 24x7classroom.edu     │        443 │ t24x7classroom.edu             │
╘════╧══════════════════════╧═══════════════════════╧════════════╧════════════════════════════════╛

```

### Useful tricks

#### Use pipe character as tableformat to fit for native Markdown table style
```python
In [22]: print(tabulate(ssl,headers='keys',tablefmt='pipe',missingval='443',showindex=range(1,len(ssl))))
```

|    | Bankfeeds services   | Production domain     |   SSL port | Uat domain                     |
|---:|:---------------------|:----------------------|-----------:|:-------------------------------|
|  1 | T4 Example           | example.com           |        443 | sit-example.com                |
|  2 | T4 abc               | abc.org               |        443 | test.abc.org                   |
|  3 | T6 24x7              | 24x7classroom.edu     |        443 | t24x7classroom.edu             |

#### Use plain as tableformat for simple
```python
In [23]: print(tabulate(ssl,headers='keys',tablefmt='plain',missingval='443',showindex=range(1,len(ssl))))
    Bankfeeds services    Production domain    SSL port  Uat domain
 1  T4 Example            example.com          443       sit-example.com
 2  T4 abc                abc.org              443       test.abc.org
 3  T6 24x7               24x7classroom.edu    443       t24x7classroom.edu
```
