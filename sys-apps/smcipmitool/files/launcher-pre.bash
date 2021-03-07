gjl_pwd=${XDG_CONFIG_HOME:-${HOME}/.config}/smcipmitool
mkdir -p "${gjl_pwd}" || exit $?
ln -snf /usr/share/smcipmitool/jre "${gjl_pwd}"/ || exit $?
