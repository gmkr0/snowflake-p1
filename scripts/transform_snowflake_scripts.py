import os
import argparse
from pathlib import Path
from jinja2 import Template
from dotenv import load_dotenv

def process_templates(snowflake_dir, output_dir, env_file):
    # Load environment variables from .env file
    load_dotenv(env_file)
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Find all .j2 files in the snowflake directory and its subdirectories
    j2_files = list(snowflake_dir.glob('**/*.j2'))
    
    for j2_file in j2_files:
        # Read the template file
        with open(j2_file, 'r') as file:
            template = Template(file.read())
        
        # Render the template with environment variables
        rendered_template = template.render(SNOWFLAKE_IAM_USER_ARN=os.getenv('SNOWFLAKE_IAM_USER_ARN'))
        
        # Create the output file path
        # Replace the .j2 extension with the appropriate extension (e.g., .sql)
        output_file = output_dir / j2_file.relative_to(snowflake_dir).with_suffix('')
        
        # Create parent directories if they don't exist
        os.makedirs(output_file.parent, exist_ok=True)
        
        # Write the rendered template to the output file
        with open(output_file, 'w') as file:
            file.write(rendered_template)
        
        print(f"Processed: {j2_file} -> {output_file}")

def main():
    parser = argparse.ArgumentParser(description='Process Snowflake SQL templates')
    parser.add_argument('--snowflake-dir', type=Path, default=Path('snowflake'),
                      help='Directory containing Snowflake templates (default: snowflake)')
    parser.add_argument('--output-dir', type=Path, default=Path('snowflake/output'),
                      help='Output directory for processed templates (default: snowflake/output)')
    parser.add_argument('--env-file', type=Path, default=Path('config/.env'),
                      help='Path to .env file (default: config/.env)')
    
    args = parser.parse_args()
    
    process_templates(args.snowflake_dir, args.output_dir, args.env_file)

if __name__ == '__main__':
    main()
