import json
import sys

# Function to convert hex strings to integers and format the output
def convert_hex_to_int_list(json_file_path):
    try:
        # Read the JSON file
        with open(json_file_path, 'r') as file:
            hex_list = json.load(file)

        # Convert hex strings to integers
        int_list = [int(hex_str, 16) for hex_str in hex_list]

        # Format the output
        formatted_output = '[' + ' '.join(map(str, int_list)) + ']'
        print(formatted_output)
    except Exception as e:
        print(f"An error occurred: {e}")

# Main function to handle command line arguments
def main():
    if len(sys.argv) != 2:
        print("Usage: python cairo1_run_args.py <path_to_json_file>")
        sys.exit(1)

    json_file_path = sys.argv[1]
    convert_hex_to_int_list(json_file_path)

if __name__ == "__main__":
    main()
