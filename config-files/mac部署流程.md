### mac中使用剪切板 
- 获取内容： pbpaste
- 存入剪切板： pbcopy

### 先确保brew安装 安装brew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
### Mac安装依赖（基础安装以免以后还得安装）

```
 brew install libiconv readline freetype libpng jpeg mhash openssl re2c ImageMagick bison autoconf ffmpeg ImageMagick pcre zlib curl libedit unzip
```

安装iterm导入配置路径：
```

 ~/Library/Application Support/iTerm2/DynamicProfiles 
 ```
 首先查看电脑当前的bash种类
```

cat /etc/shells
```
使用命令安装pip即可
```
sudo easy_install pip
```
安装powerline 
```
pip install powerline-status --user
```
安装字体库
```
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh

```

安装oh-my-zsh
```
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```
安装高亮插件
```
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
vi ~/.zshrc
找到plugins
加上zsh-syntax-highlighting
```

可选择、命令补全
```
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions
vi ~/.zshrc
找到plugins
加上zsh-autosuggestion
```

```
eq：
plugins=(
git
zsh-autosuggestions
)

```

zsh 主题选用 显示路径和git情况

```bash
~/.oh-my-zsh/themes/robbyrussell.zsh-theme

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"
PROMPT='${ret_status} %{$fg[cyan]%}$PWD%{$reset_color%}$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

```
```
编辑 vim ~/.zshrc
setopt HIST_IGNORE_DUPS  ### 可以消除重复记录
source $ZSH/oh-my-zsh.sh
source ~/.bash_profile
```
```
最后
source ~/.zshrc
```
