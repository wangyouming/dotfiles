#!/usr/bin/env bash

platform=$(uname)

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# update submodules
git -C "${script_dir}" submodule init
git -C "${script_dir}" submodule update --recursive

# install package
# param $1: packname
function install()
{
    local pack=$1

    local pack_path=$(command -v ${pack})
    if [[ -n ${pack_path} ]]
    then
        echo ${pack} is already installed at ${pack_path}.
    else
        echo installing ${pack}...

        if [[ ${platform} == *Darwin* ]]
        then
            brew install ${pack}
        else
            sudo apt install ${pack}
        fi

        echo ${pack} installed.
    fi
}

# symlink
# param $1: source_path
# param $2: dest_path
function symlink()
{
   local source_path=$1
   local dest_path=$2

   if [[ -e ${dest_path} ]]
   then
       if [[ -h ${dest_path} ]]
       then
           echo "remove origin symlink ${dest_path}."
           rm $dest_path
        else
            renamed_path="${dest_path}_bk"
            echo "rename ${dest_path} to ${renamed_path}."
            rm ${dest_path}
        fi
   fi

   echo "symlink ${dest_path} to ${source_path}."
   ln -s -f ${source_path} ${dest_path}
}

# install brew
if [[ ${platform} == *Darwin* ]]
then
    brew_path=$(command -v brew)
    if [[ -z ${brew_path} ]]
    then
        echo installing brew...
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo brew installed.
    else
        echo brew is already installed at ${brew_path}.
    fi
fi

install ack
install autojump
install cmake
install cppcheck
install python3
install tidy
install tldr
install tmate
install tree
install tmux
install zsh

# install ag
ag_path=$(command -v ag)
if [[ -n "${ag_path}" ]]
then
    echo ag is already installed at ${ag_path}.
else
    echo installing ag...

    if [[ ${platform} == *Darwin* ]]
    then
        brew install the_silver_searcher
    else
        sudo apt install silversearcher-ag
    fi

    echo ag installed.
fi

# install autopep8
autopep8_path=$(command -v autopep8)
if [[ -n "${autopep8_path}" ]]
then
    echo autopep8 is already installed at ${autopep8_path}.
else
    echo installing autopep8...

    if [[ ${platform} == *Darwin* ]]
    then
        brew install autopep8
    else
        sudo apt install python-autopep8
    fi

    echo autopep8 installed.
fi

# install ctags
if [[ -x /usr/local/bin/ctags ]]
then
    echo Universal Ctags is already installed at /usr/local/bin/ctags.
else
    echo installing Universal Ctags...

    if [[ ${platform} == *Darwin* ]]
    then
        brew tap universal-ctags/universal-ctags
        brew install --HEAD universal-ctags
    else
        # install GNU/Linux distributions
        # needed by installing universal-ctags
        sudo apt install \
            gcc make \
            pkg-config autoconf automake \
            python3-docutils \
            libseccomp-dev \
            libjansson-dev \
            libyaml-dev \
            libxml12-dev

        pushd "${script_dir}/tools/ctags"
        ./autogen.sh
        ./configure --prefix=/usr/local
        sudo make
        sudo make install
        popd
    fi

    echo Universal Ctags installed.
fi

# install fzf
fzf_path=$(command -v fzf)
if [[ -n "${fzf_path}" ]]
then
    echo fzf is already installed at ${fzf_path}.
else
    echo installing fzf...

    if [[ ${platform} == *Darwin* ]]
    then
        brew install fzf

        # To install useful key bindings and fuzzy completion
        $(brew --prefix)/opt/fzf/install
    else
        git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi

    echo fzf installed.
fi

# install ipython
if [[ ${platform} == *Darwin* ]]
then
    install ipython
else
    install ipython3
fi

# install js-beautify
js_beautify_path=$(command -v js-beautify)
if [[ -n "${js_beautify_path}" ]]
then
    echo js-beautify is already installed at ${js_beautify_path}.
else
    echo installing js-beautify...

    sudo npm install -g js-beautify

    echo js-beautify installed.
fi

# install llvm
if command -v clang >/dev/null
then
    echo llvm is already installed.
else
    echo installing llvm...
    if [[ ${platform} == *Darwin* ]]
    then
        brew install llvm
    else
        sudo apt install llvm
    fi
    echo llvm installed.
fi

# install nodejs
node_path=$(command -v node)
if [[ -n "${node_path}" ]]
then
    echo nodejs is already installed at ${node_path}.
else
    echo installing nodejs...

    if [[ ${platform} == *Darwin* ]]
    then
        brew install node
    else
        sudo apt install nodejs
        sudo apt install npm
    fi

    echo nodejs installed.
fi

# install pip
pip_path=$(command -v pip)
if [[ -n "${pip_path}" ]]
then
    echo pip is already installed at ${pip_path}.
else
    echo 'installing pip...'

    temp_dir=$(mktemp -d)
    get_pip_path="${temp_dir}/get-pip.py"
    curl https://bootstrap.pypa.io/get-pip.py -o "${get_pip_path}"
    python "${get_pip_path}"

    echo 'pip installed.'
fi

# install pylint
pylint_path=$(command -v pylint)
if [[ -n "${pylint_path}" ]]
then
    echo pylint is already installed at ${pylint_path}.
else
    echo 'installing pylint...'

    python3 -m pip install pylint

    echo 'pylint installed.'
fi

# install ipdb
python3 -m pip show ipdb &>/dev/null
if [[ $? == 0 ]]
then
    echo 'ipdb (python package) is already installed.'
else
    echo installing ipdb...

    python3 -m pip install ipdb

    echo ipdb installed.
fi

ranger_path=$(command -v ranger)
if [[ -n "${ranger_path}" ]]
then
    echo ranger is already installed at ${ranger_path}.
else
    install ranger
    ranger --copy-config=all
fi

# install svn
svn_path=$(command -v svn)
if [[ -n "${svn_path}" ]]
then
    echo svn is already installed at ${svn_path}.
else
    echo installing svn...

    if [[ "${platform}" == *Darwin* ]]
    then
        brew install subversion
    else
        sudo apt install subversion
    fi

    echo svn installed.
fi

mkdir -p ~/.tmux/plugins
if [[ -d ~/.tmux/plugins/tpm ]]
then
    echo tpm is already installed at ~/.tmux/plugins/tpm.
else
    echo installing tpm...

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    echo tpm installed.
fi

# install vim
vim_path=$(command -v vim)
if [[ -n "${vim_path}" ]]
then
    echo vim is already installed at ${vim_path}.
else
    echo installing vim...
    if [[ ${platform} == *Darwin* ]]
    then
        install vim
    else
        install vim-gtk
    fi
    echo vim installed.
fi

# install vimgolf
vimgolf_path=$(command -v vimgolf)
if [[ -n "${vimgolf_path}" ]]
then
    echo vimgolf is already installed.
else
    echo installing vimgolf...
    sudo gem install vimgolf
    echo vimgolf installed.
fi


# install oh-my-zsh
if [[ -d ~/.oh-my-zsh ]]
then
    echo oh-my-zsh is already installed at ~/.oh-my-zsh.
else
   echo installing oh-my-zsh...
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   echo oh-my-zsh installed.
fi

# install virtualenv
virtualenv_path=$(command -v virtualenv)
if [[ -n "${virtualenv_path}" ]]
then
    echo virtualenv is already installed at ${virtualenv_path}.
else
    echo installing virtualenv...

    python3 -m pip install virtualenv

    echo virtualenv installed.
fi

# install virtualenvwrapper
virtualenvwrapper_path=$(command -v virtualenvwrapper.sh)
if [[ -n "${virtualenvwrapper_path}" ]]
then
    echo virtualenvwrapper is already installed at ${virtualenvwrapper_path}.
else
    echo installing virtualenvwrapper...

    python3 -m pip install virtualenvwrapper

    echo virtualenvwrapper installed.
fi
mkdir -p "$HOME/.virtualenvs"

# install when-changed
when_changed_path=$(command -v when-changed)
if [[ -n "${when_changed_path}" ]]
then
    echo when-changed is already installed at ${when_changed_path}.
else
    echo installing when-changed

    python3 -m pip install when-changed

    echo when-changed installed.
fi

# symlink .clang-format
symlink "${script_dir}/clang-format/clang-format.txt" ~/.clang-format

# symlink .gitignore_global
symlink "${script_dir}/git/gitignore_global.txt" ~/.gitignore_global

# symlink
symlink "${script_dir}/vim/UltiSnips" $HOME/.vim/UltiSnips

# symlink .vimrc
symlink "${script_dir}/vim/vimrc.vim" ~/.vimrc

# symlink oh-my-tmux
symlink "${script_dir}/tools/oh-my-tmux/.tmux.conf" ~/.tmux.conf
symlink "${script_dir}/tmux/tmux.conf.local" ~/.tmux.conf.local

# symlink ycm_extra_conf.py as fallback of YouComplete completion.
symlink "${script_dir}/vim/ycm_extra_conf.py" ~/.ycm_extra_conf.py

# setup git global config
source "${script_dir}/git/setup.sh"

sed -i.bak 's/^plugins=.*$/plugins=(git ruby autojump osx mvn gradle tmux vi-mode)/' ~/.zshrc

grep -q "source ${script_dir}/zsh/source.sh" ~/.zshrc || \
    echo "source ${script_dir}/zsh/source.sh" >> ~/.zshrc

