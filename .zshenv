function checkSource() {
    local file=$1
    [ -f "$file" ] && source "$file"
}
function fzfPreview() {
    if [[ -d $1 ]]; then
        ls -l $1
    elif [[ -f $1 ]]; then
        batcat --theme=zenburn --color=always --style=header,grid,numbers --line-range :300 $1
    fi
}
