# gentoo prompt theme

prompt_gentoo_help () {
  cat <<'EOF'
This prompt is color-scheme-able.  You can invoke it thus:

  prompt gentoo [<promptcolor> [<usercolor> [<rootcolor>]]]

EOF
}

prompt_gentoo_setup () {
  local prompt_gentoo_prompt=${1:-'blue'}
  local prompt_gentoo_user=${2:-'green'}
  local prompt_gentoo_root=${3:-'red'}

  if [ "$EUID" = '0' ]
  then
    local base_prompt="%B%F{$prompt_gentoo_root}%m%k "
  else
    local base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
  fi
  local post_prompt="%b%f%k"

  #setopt noxtrace localoptions

  local path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
  typeset -g PS1="$base_prompt$path_prompt %# $post_prompt"
  typeset -g PS2="$base_prompt$path_prompt %_> $post_prompt"
  typeset -g PS3="$base_prompt$path_prompt ?# $post_prompt"
}

prompt_gentoo_setup "$@"
