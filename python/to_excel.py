import os
import sys
import json
import openpyxl
import tempfile

cell_values = json.loads(sys.stdin.read())

# Get the actual file path
template_file_path = "/myapp/db/documents/template.xlsx"

try:
    wb = openpyxl.load_workbook(template_file_path)
except Exception as e:
    print("Failed to load template Excel file.")
    print(e)
    sys.exit(1)

ws = wb.worksheets[0]

for cell, value in cell_values.items():
    ws[cell] = value

tmp = tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False)

try:
    wb.save(tmp.name)
except Exception as e:
    print("Failed to save Excel file.")
    print(e)
    sys.exit(1)

tmp.close()

# Print the path of the generated Excel file to stdout
print(tmp.name)

# Verify that the file exists and is readable
print("File exists after write: {}".format(os.path.exists(tmp.name)))
print("File is readable after write: {}".format(os.access(tmp.name, os.R_OK)))

# Change the owner and permission of the generated Excel file
os.chown(tmp.name, 0, 0)
os.chmod(tmp.name, 0o644)
