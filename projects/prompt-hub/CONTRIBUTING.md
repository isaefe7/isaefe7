# Contributing

Thank you for helping to improve the library.

## Add a prompt

1. Copy an existing file in `prompts/<category>/` and change it. Categories are the folder names under `prompts/`; the `category` in the front matter must match the folder.
2. Keep the structure:

   ```markdown
   ---
   title: ...
   category: <folder name>
   audience: ...
   ---
   # Title

   ## Purpose
   ## Prompt          <- exactly one ```text block with {{variables}}
   ## Variables       <- table: | `name` | description | example |
   ## Tips
   ## Watch out for
   ```

3. Use lowercase names with underscores for variables (`class_size`, not `Class Size`).
4. Run the checks before you open a pull request:

   ```bash
   python scripts/check_prompts.py --write-index
   pytest -q
   ```

## Guidelines

- Write constraints that can be checked (numbers, counts, formats).
- Say in **Watch out for** how the answer can be wrong, and how to check it.
- Never include real student data, names or copyrighted text in examples.
- One prompt, one job. Split long prompts that try to do several things.
