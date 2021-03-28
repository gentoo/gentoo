# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# @ECLASS: autotools-utils.eclass
# @MAINTAINER:
# Maciej Mrozowski <reavertm@gentoo.org>
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: common ebuild functions for autotools-based packages
# @DEPRECATED: out-of-source
# @DESCRIPTION:
# autotools-utils.eclass is autotools.eclass(5) and base.eclass(5) wrapper
# providing all inherited features along with econf arguments as Bash array,
# out of source build with overridable build dir location, static archives
# handling, libtool files removal.
#
# Please note that autotools-utils does not support mixing of its phase
# functions with regular econf/emake calls. If necessary, please call
# autotools-utils_src_compile instead of the latter.
#
# @EXAMPLE:
# Typical ebuild using autotools-utils.eclass:
#
# @CODE
# EAPI="2"
#
# inherit autotools-utils
#
# DESCRIPTION="Foo bar application"
# HOMEPAGE="http://example.org/foo/"
# SRC_URI="mirror://sourceforge/foo/${P}.tar.bz2"
#
# LICENSE="LGPL-2.1"
# KEYWORDS=""
# SLOT="0"
# IUSE="debug doc examples qt4 static-libs tiff"
#
# CDEPEND="
# 	media-libs/libpng:0
# 	qt4? (
# 		dev-qt/qtcore:4
# 		dev-qt/qtgui:4
# 	)
# 	tiff? ( media-libs/tiff:0 )
# "
# RDEPEND="${CDEPEND}
# 	!media-gfx/bar
# "
# DEPEND="${CDEPEND}
# 	doc? ( app-doc/doxygen )
# "
#
# # bug 123456
# AUTOTOOLS_IN_SOURCE_BUILD=1
#
# DOCS=(AUTHORS ChangeLog README "Read me.txt" TODO)
#
# PATCHES=(
# 	"${FILESDIR}/${P}-gcc44.patch" # bug 123458
# 	"${FILESDIR}/${P}-as-needed.patch"
# 	"${FILESDIR}/${P}-unbundle_libpng.patch"
# )
#
# src_configure() {
# 	local myeconfargs=(
# 		$(use_enable debug)
# 		$(use_with qt4)
# 		$(use_enable threads multithreading)
# 		$(use_with tiff)
# 	)
# 	autotools-utils_src_configure
# }
#
# src_compile() {
# 	autotools-utils_src_compile
# 	use doc && autotools-utils_src_compile docs
# }
#
# src_install() {
# 	use doc && HTML_DOCS=("${BUILD_DIR}/apidocs/html/")
# 	autotools-utils_src_install
# 	if use examples; then
# 		dobin "${BUILD_DIR}"/foo_example{1,2,3} \\
# 			|| die 'dobin examples failed'
# 	fi
# }
#
# @CODE

# Keep variable names synced with cmake-utils and the other way around!

case ${EAPI:-0} in
	6) die "${ECLASS}.eclass is banned in EAPI ${EAPI}";;
	4|5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: AUTOTOOLS_AUTORECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value before calling inherit to enable running autoreconf
# in src_prepare() and adding autotools dependencies.
#
# This is usually necessary when using live sources or applying patches
# modifying configure.ac or Makefile.am files. Note that in the latter case
# setting this variable is obligatory even though the eclass will work without
# it (to add the necessary dependencies).
#
# The eclass will try to determine the correct autotools to run including a few
# external tools: gettext, glib-gettext, intltool, gtk-doc, gnome-doc-prepare.
# If your tool is not supported, please open a bug and we'll add support for it.
#
# Note that dependencies are added for autoconf, automake and libtool only.
# If your package needs one of the external tools listed above, you need to add
# appropriate packages to DEPEND yourself.
[[ ${AUTOTOOLS_AUTORECONF} ]] || : ${AUTOTOOLS_AUTO_DEPEND:=no}

# eutils for eqawarn, path_exists
inherit autotools epatch eutils libtool ltprune

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install src_test

# @ECLASS-VARIABLE: BUILD_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Build directory, location where all autotools generated files should be
# placed. For out of source builds it defaults to ${WORKDIR}/${P}_build.
#
# This variable has been called AUTOTOOLS_BUILD_DIR formerly.
# It is set under that name for compatibility.

# @ECLASS-VARIABLE: AUTOTOOLS_IN_SOURCE_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to enable in-source build.

# @ECLASS-VARIABLE: ECONF_SOURCE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify location of autotools' configure script. By default it uses ${S}.

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dodoc command.
#
# In EAPIs 4+, can list directories as well.
#
# Example:
# @CODE
# DOCS=( NEWS README )
# @CODE

# @ECLASS-VARIABLE: HTML_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dohtml command.
#
# Example:
# @CODE
# HTML_DOCS=( doc/html/ )
# @CODE

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# PATCHES array variable containing all various patches to be applied.
#
# Example:
# @CODE
# PATCHES=( "${FILESDIR}"/${P}-mypatch.patch )
# @CODE

# @ECLASS-VARIABLE: AUTOTOOLS_PRUNE_LIBTOOL_FILES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Sets the mode of pruning libtool files. The values correspond to
# prune_libtool_files parameters, with leading dashes stripped.
#
# Defaults to pruning the libtool files when static libraries are not
# installed or can be linked properly without them. Libtool files
# for modules (plugins) will be kept in case plugin loader needs them.
#
# If set to 'modules', the .la files for modules will be removed
# as well. This is often the preferred option.
#
# If set to 'all', all .la files will be removed unconditionally. This
# option is discouraged and shall be used only if 'modules' does not
# remove the files.
#
# If set to 'none', no .la files will be pruned ever. Use in corner
# cases only.

# Determine using IN or OUT source build
_check_build_dir() {
	: ${ECONF_SOURCE:=${S}}
	# Respect both the old variable and the new one, depending
	# on which one was set by the ebuild.
	if [[ ! ${BUILD_DIR} && ${AUTOTOOLS_BUILD_DIR} ]]; then
		eqawarn "The AUTOTOOLS_BUILD_DIR variable has been renamed to BUILD_DIR."
		eqawarn "Please migrate the ebuild to use the new one."

		# In the next call, both variables will be set already
		# and we'd have to know which one takes precedence.
		_RESPECT_AUTOTOOLS_BUILD_DIR=1
	fi

	if [[ ${_RESPECT_AUTOTOOLS_BUILD_DIR} ]]; then
		BUILD_DIR=${AUTOTOOLS_BUILD_DIR:-${WORKDIR}/${P}_build}
	else
		if [[ -n ${AUTOTOOLS_IN_SOURCE_BUILD} ]]; then
			: ${BUILD_DIR:=${ECONF_SOURCE}}
		else
			: ${BUILD_DIR:=${WORKDIR}/${P}_build}
		fi
	fi

	# Backwards compatibility for getting the value.
	AUTOTOOLS_BUILD_DIR=${BUILD_DIR}
	echo ">>> Working in BUILD_DIR: \"${BUILD_DIR}\""
}

# @FUNCTION: autotools-utils_src_prepare
# @DESCRIPTION:
# The src_prepare function.
#
# Supporting PATCHES array and user patches. See base.eclass(5) for reference.
autotools-utils_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	local want_autoreconf=${AUTOTOOLS_AUTORECONF}

	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"

	at_checksum() {
		find '(' -name 'Makefile.am' \
			-o -name 'configure.ac' \
			-o -name 'configure.in' ')' \
			-exec cksum {} + | sort -k2
	}

	[[ ! ${want_autoreconf} ]] && local checksum=$(at_checksum)
	epatch_user
	if [[ ! ${want_autoreconf} ]]; then
		if [[ ${checksum} != $(at_checksum) ]]; then
			einfo 'Will autoreconfigure due to user patches applied.'
			want_autoreconf=yep
		fi
	fi

	[[ ${want_autoreconf} ]] && eautoreconf
	elibtoolize --patch-only
}

# @FUNCTION: autotools-utils_src_configure
# @DESCRIPTION:
# The src_configure function. For out of source build it creates build
# directory and runs econf there. Configuration parameters defined
# in myeconfargs are passed here to econf. Additionally following USE
# flags are known:
#
# IUSE="static-libs" passes --enable-shared and either --disable-static/--enable-static
# to econf respectively.

# @VARIABLE: myeconfargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional econf arguments as Bash array. Should be defined before calling src_configure.
# @CODE
# src_configure() {
# 	local myeconfargs=(
# 		--disable-readline
# 		--with-confdir="/etc/nasty foo confdir/"
# 		$(use_enable debug cnddebug)
# 		$(use_enable threads multithreading)
# 	)
# 	autotools-utils_src_configure
# }
# @CODE
autotools-utils_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${myeconfargs+1} || $(declare -p myeconfargs) == 'declare -a'* ]] \
		|| die 'autotools-utils.eclass: myeconfargs has to be an array.'

	# Common args
	local econfargs=()

	_check_build_dir
	if "${ECONF_SOURCE}"/configure --help 2>&1 | grep -q '^ *--docdir='; then
		econfargs+=(
			--docdir="${EPREFIX}"/usr/share/doc/${PF}
		)
	fi

	# Handle static-libs found in IUSE, disable them by default
	if in_iuse static-libs; then
		econfargs+=(
			--enable-shared
			$(use_enable static-libs static)
		)
	fi

	# Append user args
	econfargs+=("${myeconfargs[@]}")

	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" > /dev/null || die
	econf "${econfargs[@]}" "$@"
	popd > /dev/null || die
}

# @FUNCTION: autotools-utils_src_compile
# @DESCRIPTION:
# The autotools src_compile function, invokes emake in specified BUILD_DIR.
autotools-utils_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	emake "$@" || die 'emake failed'
	popd > /dev/null || die
}

# @FUNCTION: autotools-utils_src_install
# @DESCRIPTION:
# The autotools src_install function. Runs emake install, unconditionally
# removes unnecessary static libs (based on shouldnotlink libtool property)
# and removes unnecessary libtool files when static-libs USE flag is defined
# and unset.
#
# DOCS and HTML_DOCS arrays are supported. See base.eclass(5) for reference.
autotools-utils_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	emake DESTDIR="${D}" "$@" install || die "emake install failed"
	popd > /dev/null || die

	# XXX: support installing them from builddir as well?
	if declare -p DOCS &>/dev/null; then
		# an empty list == don't install anything
		if [[ ${DOCS[@]} ]]; then
			# dies by itself
			dodoc -r "${DOCS[@]}"
		fi
	else
		local f
		# same list as in PMS
		for f in README* ChangeLog AUTHORS NEWS TODO CHANGES \
				THANKS BUGS FAQ CREDITS CHANGELOG; do
			if [[ -s ${f} ]]; then
				dodoc "${f}" || die "(default) dodoc ${f} failed"
			fi
		done
	fi
	if [[ ${HTML_DOCS} ]]; then
		dohtml -r "${HTML_DOCS[@]}" || die "dohtml failed"
	fi

	# Remove libtool files and unnecessary static libs
	local prune_ltfiles=${AUTOTOOLS_PRUNE_LIBTOOL_FILES}
	if [[ ${prune_ltfiles} != none ]]; then
		prune_libtool_files ${prune_ltfiles:+--${prune_ltfiles}}
	fi
}

# @FUNCTION: autotools-utils_src_test
# @DESCRIPTION:
# The autotools src_test function. Runs emake check in build directory.
autotools-utils_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die

	if make -ni check "${@}" &>/dev/null; then
		emake check "${@}" || die 'emake check failed.'
	elif make -ni test "${@}" &>/dev/null; then
		emake test "${@}" || die 'emake test failed.'
	fi

	popd > /dev/null || die
}
