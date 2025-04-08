import os
from pathlib import Path
from jinja2 import Template
from dotenv import load_dotenv

load_dotenv("config/.env")
snowflake_dir = Path('snowflake')
output_dir = snowflake_dir / 'output'

# Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Find all .j2 files in the snowflake directory and its subdirectories
j2_files = list(snowflake_dir.glob('**/*.j2'))

for j2_file in j2_files:
    # Read the template file
    with open(j2_file, 'r') as file:
        template = Template(file.read())
    
    # Render the template with environment variables
    rendered_template = template.render(SNOWFLAKE_IAM_ROLE_ARN=os.getenv('SNOWFLAKE_IAM_ROLE_ARN'), AWS_BUCKET_NAME=os.getenv('AWS_BUCKET_NAME'))
    
    # Create the output file path
    # Replace the .j2 extension with the appropriate extension (e.g., .sql)
    output_file = output_dir / j2_file.relative_to(snowflake_dir).with_suffix('')
    
    # Create parent directories if they don't exist
    os.makedirs(output_file.parent, exist_ok=True)
    
    # Write the rendered template to the output file
    with open(output_file, 'w') as file:
        file.write(rendered_template)
    
    print(f"Processed: {j2_file} -> {output_file}")
