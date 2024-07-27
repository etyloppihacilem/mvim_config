#!/bin/bash

if [[ $1 = "-u" ]]; then
    if [ ! -f $2/init.lua ]; then
        echo "Usage: -u $0 path_to_nvim_config"
        echo "Run this script while being at the root of your nvim config. (Where init.lua is)"
    else
        echo "Updating..."
        if [ -d venv_nvim ]; then
            echo "Updating python packages"
            source venv_nvim/bin/activate
            pip freeze --all | grep -v '^\-e' | cut -d = -f 1  | xargs -n 1 python3 -m pip install --upgrade
            deactivate
        else
            echo "Python venv is not installed. Script cannot update packages..."
        fi
        echo "Updating uncrustify to lastest"
        git submodule update --init
        cd uncrustify && git pull && rm -rf build && mkdir build && cd build && cmake .. && make
        # updating npm packages
        which npm
        if [ $? -eq 0 ]; then
            echo "Updating vim-language-server"
            npm update vim-language-server
        else
            echo "Node not installed. It is recommended to install it using Node Version Manager."
            echo "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
        fi
    fi
elif [ ! -f $1/init.lua ]; then
    echo "Usage: [-u] $0 path_to_nvim_config"
    echo "Run this script while being at the root of your nvim config. (Where init.lua is)"
else
    # installing python venv
    which python3
    if [ $? -eq 0 ]; then
        if [ ! -d venv_nvim ]; then
            echo "Installing python virtual environement"
            python3 -m venv venv_nvim
        else
            echo "Python venv already created"
        fi
        source venv_nvim/bin/activate
        echo "Installing python packages"
        if [ -f requirements.txt ]; then
            pip install -r requirements.txt
        else
            echo "Could not find requirements, cannot install python modules"
        fi
    else
        echo "python3 not found. Cannot initialize venv"
    fi
    # installing and compiling uncrustify
    echo "Installing and compiling uncrustify"
    git submodule update --init
    if [ -d uncrustify/build ]; then
        rm -rf uncrustify/build
    fi
    cd uncrustify && mkdir -p build && cd build && cmake .. && make
    # installing vim language server
    echo "Installing vim language server"
    which npm
    if [ $? -eq 0 ]; then
        npm install -g vim-language-server
    else
        echo "Node not installed. It is recommended to install it using Node Version Manager."
        echo "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
    fi
fi
