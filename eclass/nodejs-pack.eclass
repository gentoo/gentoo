# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nodejs-pack.eclass
# @MAINTAINER:
# Fco. Javier Félix <web@inode64.com>
# @AUTHOR:
# Fco. Javier Félix <web@inode64.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: An eclass for build NodeJS projects
# @DESCRIPTION:
# An eclass providing functions to build NodeJS packages
#
# Credits and ideas from:
#   Initial version from:
#       https://github.com/gentoo/gentoo/pull/930/files
#       https://github.com/samuelbernardo/ssnb-overlay/blob/master/eclass/npm.eclass
#       https://github.com/gentoo-mirror/lanodanOverlay/blob/master/eclass/nodejs.eclass
#       https://github.com/Tatsh/tatsh-overlay/blob/master/eclass/yarn.eclass

case ${EAPI} in
    8) ;;
    *) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NODEJS_PACK_ECLASS} ]]; then
_NODEJS_PACK_ECLASS=1

inherit nodejs

if has nodejs-mod ${INHERITED}; then
    die "nodejs-mod and nodejs-pack eclass are incompatible"
fi

RDEPEND+=" net-libs/nodejs"

# Upstream does not support stripping go packages
RESTRICT="test strip"

# @FUNCTION: nodejs-pack_src_prepare
# @DESCRIPTION:
# Nodejs preparation phase
nodejs-pack_src_prepare() {
    debug-print-function "${FUNCNAME}" "${@}"

    if ! nodejs_has_package && ! test -e package.json; then
        eerror "Unable to locate package.json"
        eerror "Consider not inheriting the nodejs-pack eclass."
        die "FATAL: Unable to find package.json"
    fi

    default_src_prepare
}

# @FUNCTION: nodejs-pack_src_compile
# @DESCRIPTION:
# General function for compiling a NodeJS module
nodejs-pack_src_compile() {
    debug-print-function "${FUNCNAME}" "${@}"

    einfo "Create pack file"
    enpm --global pack || die "pack failed"
}

# @FUNCTION: nodejs-pack_src_install
# @DESCRIPTION:
# Function for installing the package
nodejs-pack_src_install() {
    debug-print-function "${FUNCNAME}" "${@}"

    nodejs_docs

    einfo "Install pack files"
    enpm --prefix "${ED}"/usr --global \
        install \
        "$(nodejs_package)-$(nodejs_version).tgz" || die "install failed"

    pushd "${ED}/$(nodejs_modules)" >/dev/null || die
    nodejs_remove_dev
    popd >/dev/null || die
}

fi

EXPORT_FUNCTIONS src_prepare src_compile src_install
