# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nodejs-mod.eclass
# @MAINTAINER:
# Fco. Javier Félix <web@inode64.com>
# @AUTHOR:
# Fco. Javier Félix <web@inode64.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: An eclass for build NodeJS projects
# @DESCRIPTION:
# An eclass providing functions to build NodeJS projects
#
# Credits and ideas from:
#   Initial version from:
#       https://github.com/gentoo/gentoo/pull/930/files
#       https://github.com/samuelbernardo/ssnb-overlay/blob/master/eclass/npm.eclass
#       https://github.com/gentoo-mirror/lanodanOverlay/blob/master/eclass/nodejs.eclass
#       https://github.com/Tatsh/tatsh-overlay/blob/master/eclass/yarn.eclass

#
# Build package for node_modules:
#   npm:
#   npm install --audit false --color false --foreground-scripts --progress false --verbose --ignore-scripts
#
#   yarn:
#   yarn install --color false --foreground-scripts --progress false --verbose --ignore-scripts
#
#   Create archive in tar:
#   tar --create --auto-compress --file foo-1-node_modules.tar.xz foo-1/node_modules/

case ${EAPI} in
    8) ;;
    *) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NODEJS_MOD_ECLASS} ]]; then
_NODEJS_MOD_ECLASS=1

inherit nodejs

if has nodejs-pack ${INHERITED}; then
    die "nodejs-mod and nodejs-pack eclass are incompatible"
fi

RDEPEND+=" net-libs/nodejs:="

# @FUNCTION: nodejs-mod_src_prepare
# @DESCRIPTION:
# Nodejs preparation phase
nodejs-mod_src_prepare() {
    debug-print-function "${FUNCNAME}" "${@}"

    if [[ ! -e package.json ]]; then
        eerror "Unable to locate package.json"
        eerror "Consider not inheriting the NodeJS eclass."
        die "FATAL: Unable to find package.json"
    fi

    default_src_prepare
}

# @FUNCTION: nodejs-mod_src_compile
# @DESCRIPTION:
# General function for compiling a NodeJS module
nodejs-mod_src_compile() {
    debug-print-function "${FUNCNAME}" "${@}"

    if [[ -d node_modules ]]; then
        einfo "Compile native addon modules"
        find node_modules/ -name binding.gyp -exec dirname {} \; | while read -r dir; do
            pushd "${dir}" >/dev/null || die
            # shellcheck disable=SC2046
            npm_config_nodedir=/usr/ /usr/$(get_libdir)/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild --verbose
            popd >/dev/null || die
        done
    fi

    if nodejs_has_build; then
        einfo "Run build"
        enpm run build || die "build failed"
    fi
}

# @FUNCTION: nodejs-mod_src_test
# @DESCRIPTION:
# General function for testing a NodeJS module
nodejs-mod_src_test() {
    debug-print-function "${FUNCNAME}" "${@}"

    if nodejs_has_test; then
        enpm run test || die "test failed"
    fi
}

# @FUNCTION: nodejs_src_install
# @DESCRIPTION:
# Function for installing the package
nodejs-mod_src_install() {
    debug-print-function "${FUNCNAME}" "${@}"

    nodejs_docs

    enpm_clean
    enpm_install
}

fi

EXPORT_FUNCTIONS src_prepare src_compile src_test src_install
