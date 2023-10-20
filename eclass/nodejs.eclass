# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nodejs.eclass
# @MAINTAINER:
# Fco. Javier Félix <web@inode64.com>
# @AUTHOR:
# Fco. Javier Félix <web@inode64.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: An eclass for build NodeJS projects
# @DESCRIPTION:
# An eclass providing functions to build NodeJS projects
#
# Changelog:
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
7 | 8) ;;
*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NODEJS_ECLASS} ]]; then
_NODEJS_ECLASS=1

# @ECLASS_VARIABLE: NODEJS_MANAGEMENT
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify a package management
# The default is set to "npm".
: "${NODEJS_MANAGEMENT:=npm}"

# @ECLASS_VARIABLE: NODEJS_FILES
# @INTERNAL
# @DESCRIPTION:
# Files and directories that usually come in a standard NodeJS/npm module.
NODEJS_FILES="babel.config.js babel.config.json cli.js dist index.js lib node_modules package.json"

# @ECLASS_VARIABLE: NODEJS_EXTRA_FILES
# @DESCRIPTION:
# If additional dist files are present in the NodeJS/npm module that are not
# listed in NODEJS_FILES, then this is the place to put them in.
# Can be either files, or directories.
# Example: NODEJS_EXTRA_FILES="rigger.js modules"

case ${NODEJS_MANAGEMENT} in
npm)
    BDEPEND+=" net-libs/nodejs[npm]"
    ;;
yarn)
    BDEPEND+=" sys-apps/yarn"
    ;;
*)
    eerror "Unknown value for \${NODEJS_MANAGEMENT}"
    die "Value ${NODEJS_MANAGEMENT} is not supported"
    ;;
esac

# @FUNCTION: nodejs_version
# @DESCRIPTION:
# Returns the package version
nodejs_version() {
    node -p "require('./package.json').version"
}

# @FUNCTION: nodejs_package
# @DESCRIPTION:
# Returns the package name
nodejs_package() {
    node -p "require('./package.json').name"
}

# @FUNCTION: nodejs_has_test
# @DESCRIPTION:
# Returns true if test script exist
nodejs_has_test() {
    node -p "if (require('./package.json').scripts.test === undefined) { process.exit(1) }" &>/dev/null
}

# @FUNCTION: nodejs_has_build
# @DESCRIPTION:
# Returns true if build script exist
nodejs_has_build() {
    node -p "if (require('./package.json').scripts.build === undefined) { process.exit(1) }" &>/dev/null
}

# @FUNCTION: _NODEJS_MODULES
# @DESCRIPTION:
# Returns location where to install nodejs
_NODEJS_MODULES() {
    # shellcheck disable=SC2046
    echo /usr/$(get_libdir)/node_modules/$(nodejs_package)
}

# @FUNCTION: nodejs_has_package
# @DESCRIPTION:
# Returns true (0) if is a package
nodejs_has_package() {
    [[ -d "${S}"/package ]] || return 1
}

# @FUNCTION: nodejs_docs
# @DESCRIPTION:
# Install docs usually found in NodeJS/NPM packages
nodejs_docs() {
    # If docs variable is not empty when install docs usually found in NodeJS/NPM packages
    [[ ! "${DOCS}" ]] || return

    local f

    for f in README* HISTORY* ChangeLog AUTHORS NEWS TODO CHANGES \
        THANKS BUGS FAQ CREDITS CHANGELOG* *.md; do
        if [[ -s "${f}" ]]; then
            dodoc "${f}"
        fi
    done
}

# @FUNCTION: nodejs_remove_dev
# @INTERNAL
# @DESCRIPTION:
# Remove docs, licenses and development files
nodejs_remove_dev() {
    # Remove license files
    # shellcheck disable=SC2185
    find -type f -iregex '.*/\(...-\)?license\(-...\|-apache\)?\(\.\(md\|rtf\|txt\|markdown\|bsd\)\)?$' -delete || die

    # Remove documentation files
    # shellcheck disable=SC2185
    find -type f -iregex '.*/*.\.md$' -delete || die
    # shellcheck disable=SC2185
    find -type f -iregex '.*/\(readme\(.*\)?\|changelog\|roadmap\|security\|release\|contributors\|todo\|authors\)$' -delete || die

    # Remove typscript files
    # shellcheck disable=SC2185
    find -type f -iregex '.*\.\(tsx?\|jsx\|map\)$' -delete || die
    # shellcheck disable=SC2185
    find -type f -name tsconfig.json -delete || die
    # shellcheck disable=SC2185
    find -type f -name docker-compose.yml -delete || die
    # shellcheck disable=SC2185
    find -type f -iname CopyrightNotice.txt -delete || die

    # Remove misc files
    # shellcheck disable=SC2185
    find -type f -iname '*.musl.node' -delete || die
    # shellcheck disable=SC2185
    find -type f -iregex '.*\.\(editorconfig\|bak\|npmignore\|exe\|gitattributes\|ps1\|ds_store\|log\|pyc\)$' -delete || die
    # shellcheck disable=SC2185
    find -type f -iregex '.*\.\(travis.yml\|makefile\|jshintrc\|flake8\|mk\|env\|nycrc\|eslint.*\|coveralls.*\)$' -delete || die
    # shellcheck disable=SC2185
    find -type f -iregex '.*\.\(jscs.json\|jshintignore\|gitignore\|babelrc.*\|runkit_example.js\|airtap.yml\)$' -delete || die
    # shellcheck disable=SC2185
    find -type f -iregex '.*\.\(jekyll-metadata\|codeclimate.yml\|prettierrc.yaml\|drone.jsonnet\|mocharc.*\)$' -delete || die
    # shellcheck disable=SC2185
    find -type f -iname makefile -delete || die
    # shellcheck disable=SC2185
    find -type f -name '*\~' -delete || die

    # shellcheck disable=SC2185
    find -type d \
        \( \
        -iwholename '*.github' -o \
        -iwholename '*.tscache' -o \
        -iwholename '*.vscode' -o \
        -iwholename '*.idea' -o \
        -iwholename '*.nyc_output' -o \
        -iwholename '*.deps' -o \
        -iwholename '*/man' -o \
        -iwholename '*/test' -o \
        -iwholename '*/scripts' -o \
        -iwholename '*/git-hooks' -o \
        -iwholename '*/prebuilds' -o \
        -iwholename '*/android-arm' -o \
        -iwholename '*/android-arm64' -o \
        -iwholename '*/linux-arm64' -o \
        -iwholename '*/linux-armvy' -o \
        -iwholename '*/linux-armv7' -o \
        -iwholename '*/linux-arm' -o \
        -iwholename '*/win32-ia32' -o \
        -iwholename '*/win32-x64' -o \
        -iwholename '*/darwin-x64' \
        -iwholename '*/darwin-x64+arm64' \
        \) \
        -exec rm -rvf {} +
}

# @FUNCTION: enpm
# @DESCRIPTION:
# Packet manager execution wrapper
enpm() {
    debug-print-function "${FUNCNAME}" "${@}"

    local mynpmflags_local mynpmflagstype npmflags

    # Make the array a local variable since <=portage-2.1.6.x does not support
    # global arrays (see bug #297255). But first make sure it is initialised.
    [[ -z ${mynpmflags} ]] && declare -a mynpmflags=()
    mynpmflagstype=$(declare -p mynpmflags 2>&-)
    if [[ "${mynpmflagstype}" != "declare -a mynpmflags="* ]]; then
        die "mynpmflags must be declared as array"
    fi

    mynpmflags_local=("${mynpmflags[@]}")

    npmflags=(
        --color false
        --foreground-scripts
        --offline
        --progress false
        --verbose
        "${mynpmflags_local[@]}"
    )

    case ${NODEJS_MANAGEMENT} in
    npm)
        npmflags+=(
            --audit false
        )
        npm "$@" "${npmflags[@]}"
        ;;
    yarn)
        npmflags+=(
            --cache-folder "${S}/.cache"
        )
        yarn "$@" "${npmflags[@]}"
        ;;
    esac
}

# @FUNCTION: enpm_clean
# @DESCRIPTION:
# Delete all unnecessary files
enpm_clean() {
    debug-print-function "${FUNCNAME}" "${@}"

    local nodejs_files f

    einfo "Clean files"
    case ${NODEJS_MANAGEMENT} in
    npm)
        enpm prune --omit=dev || die
        ;;
    yarn)
        enpm install production || die
        # TODO
        #enpm autoclean --init || die
        #enpm autoclean --force || die
        ;;
    esac

    nodejs_files="${NODEJS_FILES} ${NODEJS_EXTRA_FILES}"

    # Cleanups
    for f in ${nodejs_files}; do
        if [[ -d "${S}/${f}" ]]; then
            pushd "${S}/${f}" >/dev/null || die
            nodejs_remove_dev
            popd >/dev/null || die
        fi
    done
}

# @FUNCTION: enpm_install
# @DESCRIPTION:
# Install the files and folders necessary for the execution of nodejs
enpm_install() {
    debug-print-function "${FUNCNAME}" "${@}"

    local nodejs_files f

    if nodejs_has_package; then
        einfo "Install pack files"
        enpm --prefix "${ED}"/usr \
            install \
            "$(nodejs_package)-$(nodejs_version).tgz" || die "install failed"
    fi

    nodejs_files="${NODEJS_FILES} ${NODEJS_EXTRA_FILES} $(nodejs_package).js"

    dodir "$(_NODEJS_MODULES)" || die "Could not create DEST folder"

    for f in ${nodejs_files}; do
        if [[ -e "${S}/${f}" ]]; then
            cp -r "${S}/${f}" "${ED}/$(_NODEJS_MODULES)"
        fi
    done
}

fi
