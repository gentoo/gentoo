# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: yarn.eclass
# @MAINTAINER:
# Andrew Udvare <audvare@gmail.com>
# @AUTHOR:
# Andrew Udvare <audvare@gmail.com>
# @BLURB: Install a Node-based package offline with Yarn.
# @DESCRIPTION:
# An eclass for installing packages from Node/Yarn, but with Yarn as the
# package manager instead of npm. The reason for this is due to Yarn's offline
# package support.
#
# Any package inheriting this eclass must include package.json and yarn.lock
# files from a pseudo-project. One possible way to generate these files:
# @CODE
#
# cd new-project-dir
# echo 'yarn-offline-mirror=SOME_DIR' > .yarnrc
# yarn init
# yarn add PACKAGE_NAME [PEER_DEP_NAME PEER_DEP_NAME_2 ...]
#
# @CODE
# Do not forget to add peer dependencies to your pseudo-project.
#
# To get the package specs for the YARN_PKGS array, yarn.lock can be parsed.
# The syntax for yarn.lock is non-trivial but for simple packages the following
# command may generate most of the lines:
# @CODE
#
# grep -E '^"?[a-z]' yarn.lock | sed -re 's/@\^/-/' -e 's/://'
#
# @CODE
# If a line with multiple versions of a package is encountered (a comma will be
# in the line), all versions in the line must be included in YARN_PKGS.
#
# Some common pre-built packages are removed by this eclass, but if there are
# others your package is pulling in, you should delete those prior to calling
# yarn_src_compile.
#
# This eclass does not add dev-util/node-gyp to dependencies. If your package
# has anything that must be compiled, you probably should add dev-util/node-gyp
# to BDEPEND.

case ${EAPI:-0} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} unsupported." ;;
esac

inherit edo multiprocessing

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install

if [[ -z ${_YARN_ECLASS} ]]; then
# @ECLASS_VARIABLE: YARN_PKGS
# @DESCRIPTION:
# Bash array of Yarn package specifications in format [@SCOPE/]NAME-VERSION.
# @CODE
#
# YARN_PKGS=(
#   @types/type-pkg-1.0.0
#   non-scoped-project-name-1.2.3
#  )
#
# @CODE

# @ECLASS_VARIABLE: YARN_PACKAGE_JSON
# @DESCRIPTION:
# Full path to package.json. Defaults to ${FILESDIR}/${PN}-package.json.

# @ECLASS_VARIABLE: YARN_LOCK
# @DESCRIPTION:
# Full path to yarn.lock. Defaults to ${FILESDIR}/${PN}-yarn.lock.

# @ECLASS_VARIABLE: _YARN_DISTFILES
# @INTERNAL:
# @DESCRIPTION:
# Array of distfile basenames. The output path for a tarball may be
# different than the basename taken off the URI.
_YARN_DISTFILES=()

# @FUNCTION: yarn_set_globals
# @DESCRIPTION:
# This must be called after defining YARN_PKGS in global scope. This
# function sets up YARN_SRC_URI which must be added to SRC_URI. If you need
# to be certain that BDEPEND/RDEPEND/RESTRICT/SLOT is empty, set those
# after calling this.
yarn_set_globals() {
	BDEPEND="sys-apps/yarn"
	RDEPEND="net-libs/nodejs:="
	RESTRICT="strip"
	SLOT="0"
	local -r regex='^(@[a-zA-Z0-9_-]+/)?([a-zA-Z0-9\._-]+)-([0-9]+\.[0-9]+\.[0-9]+.*)'
	local -r newline=$'\n'
	if [[ -z ${YARN_PKGS} ]]; then
		eerror "YARN_PKGS variable is not defined"
		die "Can't generate SRC_URI from empty input"
	fi
	for pkg in "${YARN_PKGS[@]}"; do
		local name version prefix out
		[[ ${pkg} =~ ${regex} ]] || die "Could not parse name and version from spec: ${pkg}"
		scope="${BASH_REMATCH[1]}"
		name="${BASH_REMATCH[2]}"
		version="${BASH_REMATCH[3]}"
		prefix=
		if [ -n "${scope}" ]; then
			prefix="-${scope/\//}"
		fi
		out="node${prefix}-${name}-${version}.tgz"
		YARN_SRC_URI+=" https://registry.yarnpkg.com/${scope}${name}/-/${name}-${version}.tgz -> ${out}${newline}"
		_YARN_DISTFILES+=( "$out" )
	done
	_YARN_SET_GLOBALS_CALLED=1
	readonly YARN_PKGS
	readonly YARN_SRC_URI
}

# @FUNCTION: yarn_src_unpack
# @DESCRIPTION:
# Unpacks normal packages but ignores those ending in .tgz.
yarn_src_unpack() {
	local archive
	for archive in ${A}; do
		case "${archive}" in
		*.tgz) ;;

		*)
			unpack "${archive}"
			;;
		esac
	done
}

# @FUNCTION: yarn_src_prepare
# @DESCRIPTION:
# Prepares up the offline Yarn package files.
yarn_src_prepare() {
	if [[ ! ${_YARN_SET_GLOBALS_CALLED} ]]; then
		die "yarn_set_globals must be called in global scope"
	fi
	mkdir lib packages || die
	local file bn
	for file in "${_YARN_DISTFILES[@]}"; do
		bn=$(basename "$file")
		ln -s "${DISTDIR}/${file}" "packages/${bn:5}" || die
	done
	default
}

# @FUNCTION: yarn_src_configure
# @DESCRIPTION:
# Sets up the offline Yarn environment.
yarn_src_configure() {
	edo yarn config set prefix "${HOME}/.node"
	edo yarn config set yarn-offline-mirror "$(realpath "${WORKDIR}/packages")"
}

# @FUNCTION: yarn_src_compile
# @DESCRIPTION:
# Using Yarn's offline mode, this function installs the package as it would normally and
# compiles anything that needs to be.
yarn_src_compile() {
	cd lib || die
	cp "${YARN_PACKAGE_JSON:-${FILESDIR}/${PN}-package.json}" package.json || die
	cp "${YARN_LOCK:-${FILESDIR}/${PN}-yarn.lock}" yarn.lock || die
	edo env \
		"npm_config_jobs=$(makeopts_jobs)" \
		npm_config_verbose=true \
		npm_config_release=true \
		"npm_config_nodedir=${EPREFIX}/usr/include/node" \
		yarn install --production --offline --verbose --no-progress \
			--non-interactive --build-from-source
	# Delete known pre-built binaries
	rm -fR \
		node_modules/@serialport/bindings-cpp/prebuilds/{darwin,android,win32,linux-arm}* \
		node_modules/@serialport/bindings-cpp/prebuilds/linux-x64/*musl.node \
		package.json || die
	find . -type d -empty -delete || die
	# Delete files that need compilation and related unused files at
	# runtime as we only want distributed .js files
	find . -type f -iregex '.*\.\(tsx?\|jsx\|map\)' -delete || die
}

# @FUNCTION: yarn_src_install
# @DESCRIPTION:
# Installs the package into /usr/$(get_libdir)/${PN}/node_modules and installs docs.
yarn_src_install() {
	find . -type f -iregex '.*/license\(\.\(md\|rtf\|txt\)\)?' -delete || die
	insinto "/usr/$(get_libdir)/${PN}/node_modules"
	doins -r lib/node_modules/*
	einstalldocs
}
_YARN_ECLASS=1
fi
