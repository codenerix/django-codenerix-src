#!/bin/bash

REPOS=""
REPOS="$REPOS https://github.com/angular/material"
REPOS="$REPOS https://github.com/angular/angular.js"
REPOS="$REPOS https://github.com/evert0n/angular-color-contrast"
REPOS="$REPOS https://github.com/VividCortex/angular-recaptcha"
REPOS="$REPOS https://github.com/janantala/angular-qr"
REPOS="$REPOS https://github.com/angular-ui/bootstrap"
REPOS="$REPOS https://github.com/angular-ui/ui-router"
REPOS="$REPOS https://github.com/angular-ui/ui-select"
REPOS="$REPOS https://github.com/angular-ui/ui-utils"
REPOS="$REPOS https://github.com/adonespitogo/angular-base64-upload"
REPOS="$REPOS https://github.com/buberdds/angular-bootstrap-colorpicker"
REPOS="$REPOS https://github.com/frapontillo/angular-bootstrap-switch"
REPOS="$REPOS https://github.com/chieffancypants/angular-loading-bar"
REPOS="$REPOS https://github.com/twbs/bootstrap"
REPOS="$REPOS https://github.com/flatlogic/bootstrap-tabcollapse"
REPOS="$REPOS https://github.com/smalot/bootstrap-datetimepicker"
REPOS="$REPOS https://github.com/Bttstrp/bootstrap-switch"
REPOS="$REPOS https://github.com/vitalets/checklist-model"
REPOS="$REPOS https://github.com/dangrossman/bootstrap-daterangepicker"
REPOS="$REPOS https://github.com/jrief/django-angular"
REPOS="$REPOS https://github.com/FortAwesome/Font-Awesome"
REPOS="$REPOS https://github.com/l-lin/font-awesome-animation"
REPOS="$REPOS https://github.com/chieffancypants/angular-hotkeys"
REPOS="$REPOS https://github.com/components/jquery-htmlclean"
REPOS="$REPOS https://github.com/aFarkas/html5shiv"
REPOS="$REPOS https://github.com/jquery/jquery"
REPOS="$REPOS https://github.com/moment/moment"
REPOS="$REPOS https://github.com/jpillora/notifyjs"
REPOS="$REPOS https://github.com/nohros/nsPopover"
REPOS="$REPOS https://github.com/slab/quill"
REPOS="$REPOS https://github.com/timdown/rangy"
REPOS="$REPOS https://github.com/fraywing/textAngular"

# Calculate total repos
total=0
for repo in $REPOS; do
    total=$((total+1))
done

# Update each repo
counter=1
errors=""
for repo in $REPOS; do

    # If no error and not in the first round, print a green ok
    # else if we are not in the first round, write a red one
    if [ $counter -gt 1 ]; then
        if [ -z "$errors" ]; then
            # Get green color
            color="\033[32m"
        else
            # Get red color
            color="\033[31m"
        fi
    fi
    echo -en "${color}[$(printf "%2s" $counter)/$total]\033[0m - Processing $repo..."

    # Find folder name
    folder=$(echo "$repo" | awk -F'/' '{print $NF}' | sed 's/.git//')

    # If folder doesn't exist, clone the repo
    [ ! -d "$folder" ] && echo "---> Cloning $repo..." && git clone "$repo"

    # Backup .git folder
    [ -d "$folder/.git.bak" ] && mv "$folder/.git.bak" "$folder/.git"

    # Update the repo
    cd "$folder" && git pull > /dev/null &&  cd .. && error=0 || error=1
    if [ $error -eq 1 ]; then
        # Show a red cross and a red message
        echo -e "\033[31mERROR: $repo not updated! <--- !!! !!! !!! \xE2\x9C\x98\033[0m\n"
        errors="$errors $repo"
        continue
    fi

    # Restore .git folder
    mv "$folder/.git" "$folder/.git.bak"

    # Show a green tick
    echo -e "\033[32m\xE2\x9C\x94\033[0m"

    counter=$((counter+1))

done

echo -e "\n\n\n"

# Show summary
if [ -n "$errors" ]; then

    # Calculate total errors
    total_errors=0
    for repo in $REPOS; do
        if [[ $errors == *"$repo"* ]]; then
            total_errors=$((total_errors+1))
        fi
    done

    # Show errors
    echo " Found $total_errors ERRORS:"
    echo " ==============="
    echo
    for repo in $errors; do
        echo "    > ERROR at $repo"
        echo
    done
    echo
    exit 1
else
    echo -e "\033[32mAll repos updated successfully!\033[0m"
    echo
fi

exit 0
