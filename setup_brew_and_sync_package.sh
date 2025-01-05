#!/bin/zsh

# 下载 Homebrew 包和 cask 列表
echo "正在下载 Homebrew 包和 cask 列表..."
curl -L https://raw.githubusercontent.com/flamintune/my-brew-list/main/brew-casks.txt -o brew-casks.txt
curl -L https://raw.githubusercontent.com/flamintune/my-brew-list/refs/heads/main/brew-packages.txt -o brew-packages.txt

# 安装 Homebrew
echo "正在安装 Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 检查 shell 类型并配置 PATH
if [[ $SHELL == *zsh ]]; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
    echo "配置 PATH 变量到 ~/.zshrc"
    source ~/.zshrc
elif [[ $SHELL == *bash ]]; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
    echo "配置 PATH 变量到 ~/.bash_profile"
    source ~/.bash_profile
else
    echo "未知的 shell 类型: $SHELL"
    exit 1
fi

# 验证 Homebrew 安装
echo "检查 Homebrew 安装..."
brew doctor

# 恢复之前安装的 packages
echo "正在恢复 Homebrew packages..."
while read package; do
    brew install $package
done < brew-packages.txt

# 恢复之前安装的 casks
echo "正在恢复 Homebrew casks..."
while read cask; do
    brew install --cask $cask
done < brew-casks.txt

# 安装完成提示
if [ $? -eq 0 ]; then
    echo "Homebrew 及应用恢复成功！"
    # 删除下载的文件
    echo "正在删除临时文件..."
    rm brew-packages.txt brew-casks.txt
    echo "临时文件已删除。"
else
    echo "恢复过程可能出现问题，请检查上述输出信息以确定错误原因。"
fi
