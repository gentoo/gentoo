gjl_pwd=${XDG_CONFIG_HOME:-${HOME}/.config}/ipmiview
mkdir -p "${gjl_pwd}" || exit $?
ln -snf /usr/share/ipmiview/jre "${gjl_pwd}"/ || exit $?
