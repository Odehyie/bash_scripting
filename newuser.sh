#!/bin/bash

# Function to create a new user on macOS
create_user() {
    # Prompt for the username
    read -p "Enter the new username: " username

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
        exit 1
    fi

    # Prompt for the password
    read -s -p "Enter the password for $username: " password
    echo
    read -s -p "Confirm the password: " password_confirm
    echo

    # Check if the passwords match
    if [ "$password" != "$password_confirm" ]; then
        echo "Passwords do not match."
        exit 1
    fi

    # Create the user
    sudo dscl . -create /Users/"$username"
    sudo dscl . -create /Users/"$username" UserShell /bin/bash
    sudo dscl . -create /Users/"$username" RealName "$username"
    sudo dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
    sudo dscl . -passwd /Users/"$username" "$password"

    # Create the user's home directory
    sudo createhomedir -c 2>/dev/null

    echo "User '$username' created successfully."
}

# Execute the function
create_user
