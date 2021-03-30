# collapsible markdown

### Usage
```html
<details><summary><i>Example - tablefmt</i></summary>

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

</details>
```

### Example

<details><summary><i>Show example</i></summary>

```python
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
```

</details>
