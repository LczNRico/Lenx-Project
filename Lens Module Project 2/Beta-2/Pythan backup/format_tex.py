#!/usr/bin/env python3
"""
Format .tex file with GeoGebra expressions.
- Simple functions (2-3 params like Segment, Sphere, Ray) stay on one line
- Complex nested structures (If, Intersect, CircularArc with nesting) expand with 4-space indentation
"""

import re

def count_nesting_depth(text):
    """Count the maximum nesting depth of parentheses in text."""
    depth = 0
    max_depth = 0
    for char in text:
        if char == '(':
            depth += 1
            max_depth = max(max_depth, depth)
        elif char == ')':
            depth -= 1
    return max_depth

def is_simple_function(text):
    """
    Check if a function call is simple (should stay on one line).
    Simple = 2-3 parameters with no deep nesting.
    """
    # Remove the function call to get parameters
    match = re.match(r'(\w+)\((.*)\)', text.strip())
    if not match:
        return False

    func_name = match.group(1)
    params = match.group(2)

    # Simple functions we want to keep on one line
    simple_funcs = ['Segment', 'Sphere', 'Ray', 'Plane']

    # Count commas at depth 0 to get parameter count
    depth = 0
    param_count = 1 if params.strip() else 0
    for char in params:
        if char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
        elif char == ',' and depth == 0:
            param_count += 1

    # Check nesting depth
    nesting_depth = count_nesting_depth(params)

    # Keep on one line if:
    # 1. It's a known simple function with low nesting (<=2)
    # 2. Or has 2-3 params and nesting depth <= 1
    if func_name in simple_funcs and nesting_depth <= 2:
        return True
    if param_count <= 3 and nesting_depth <= 1:
        return True

    return False

def format_expression(text, indent_level=0):
    """
    Format a GeoGebra expression with proper indentation.
    """
    indent = '    ' * indent_level
    text = text.strip()

    if not text:
        return ''

    # Check if this is a simple function that should stay on one line
    if is_simple_function(text):
        return text

    # Find the function name
    match = re.match(r'(\w+)\((.*)\)$', text, re.DOTALL)
    if not match:
        return text

    func_name = match.group(1)
    params_text = match.group(2)

    # Split parameters at depth 0
    params = []
    current_param = ''
    depth = 0
    for char in params_text:
        if char == '(':
            depth += 1
            current_param += char
        elif char == ')':
            depth -= 1
            current_param += char
        elif char == ',' and depth == 0:
            params.append(current_param.strip())
            current_param = ''
        else:
            current_param += char

    if current_param.strip():
        params.append(current_param.strip())

    # Format each parameter
    formatted_params = []
    for param in params:
        formatted_param = format_expression(param, indent_level + 1)
        formatted_params.append(formatted_param)

    # Build the formatted output
    if len(formatted_params) == 0:
        return f"{func_name}()"

    # Check if all params are simple and can fit on separate lines without sub-indentation
    all_simple = all(not re.match(r'(\w+)\(', p) or is_simple_function(p) for p in formatted_params)

    result = f"{func_name}(\n"
    for i, param in enumerate(formatted_params):
        next_indent = '    ' * (indent_level + 1)
        if i < len(formatted_params) - 1:
            result += f"{next_indent}{param},\n"
        else:
            result += f"{next_indent}{param}\n"
    result += f"{indent})"

    return result

def process_file(input_path, output_path):
    """Process the entire file."""
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The file starts with "Incident_{1st,InRe}=" followed by the expression
    lines = content.split('\n', 1)
    if len(lines) == 2 and lines[0].strip().startswith('Incident_{1st,InRe}='):
        header = lines[0].strip()
        expression = lines[1].strip()
    else:
        # Try to find the pattern in the content
        match = re.match(r'(.*?Incident_\{1st,InRe\}=)\s*(.*)', content, re.DOTALL)
        if match:
            header = match.group(1).strip()
            expression = match.group(2).strip()
        else:
            print("Could not parse file format")
            return

    # Format the expression
    formatted_expr = format_expression(expression, indent_level=0)

    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(f"{header}\n{formatted_expr}\n")

    print(f"Formatted file written to {output_path}")

if __name__ == '__main__':
    input_file = r"c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}.tex"
    output_file = r"c:\Users\user\Desktop\Geogebra\Lens Module Project 2\Beta\Point\Incident_{1st,InRe}_formatted.tex"

    process_file(input_file, output_file)
