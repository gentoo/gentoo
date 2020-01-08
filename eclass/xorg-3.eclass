# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xorg-3.eclass
# @MAINTAINER:
# x11@gentoo.org
# @AUTHOR:
# Author: Tomáš Chvátal <scarabeus@gentoo.org>
# Author: Donnie Berkholz <dberkholz@gentoo.org>
# Author: Matt Turner <mattst88@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Reduces code duplication in the modularized X11 ebuilds.
# @DESCRIPTION:
# This eclass makes trivial X ebuilds possible for apps, drivers,
# and more. Many things that would normally be done in various functions
# can be accessed by setting variables instead, such as patching,
# running eautoreconf, passing options to configure and installing docs.
#
# All you need to do in a basic ebuild is inherit this eclass and set
# DESCRIPTION, KEYWORDS and RDEPEND/DEPEND. If your package is hosted
# with the other X packages, you don't need to set SRC_URI. Pretty much
# everything else should be automatic.

GIT_ECLASS=""
if [[ ${PV} == *9999* ]]; then
	GIT_ECLASS="git-r3"
	XORG_EAUTORECONF="yes"
fi

# @ECLASS-VARIABLE: XORG_MULTILIB
# @DESCRIPTION:
# If set to 'yes', the multilib support for package will be enabled. Set
# before inheriting this eclass.
: ${XORG_MULTILIB:="no"}

# we need to inherit autotools first to get the deps
inherit autotools libtool multilib toolchain-funcs flag-o-matic ${GIT_ECLASS}

if [[ ${XORG_MULTILIB} == yes ]]; then
	inherit multilib-minimal
fi

EXPORTED_FUNCTIONS="src_prepare src_configure src_unpack src_compile src_install"
case "${EAPI:-0}" in
	7) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# exports must be ALWAYS after inherit
EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

IUSE=""

# @ECLASS-VARIABLE: XORG_EAUTORECONF
# @DESCRIPTION:
# If set to 'yes' and configure.ac exists, eautoreconf will run. Set
# before inheriting this eclass.
: ${XORG_EAUTORECONF:="no"}

# @ECLASS-VARIABLE: XORG_BASE_INDIVIDUAL_URI
# @DESCRIPTION:
# Set up SRC_URI for individual modular releases. If set to an empty
# string, no SRC_URI will be provided by the eclass.
: ${XORG_BASE_INDIVIDUAL_URI="https://www.x.org/releases/individual"}

# @ECLASS-VARIABLE: XORG_MODULE
# @DESCRIPTION:
# The subdirectory to download source from. Possible settings are app,
# doc, data, util, driver, lib, proto, xserver. Set above the
# inherit to override the default autoconfigured module.
: ${XORG_MODULE:="auto"}
if [[ ${XORG_MODULE} == auto ]]; then
	case ${CATEGORY} in
		app-doc)             XORG_MODULE=doc/     ;;
		media-fonts)         XORG_MODULE=font/    ;;
		x11-apps|x11-wm)     XORG_MODULE=app/     ;;
		x11-misc|x11-themes) XORG_MODULE=util/    ;;
		x11-base)            XORG_MODULE=xserver/ ;;
		x11-drivers)         XORG_MODULE=driver/  ;;
		x11-libs)            XORG_MODULE=lib/     ;;
		*)                   XORG_MODULE=         ;;
	esac
fi

# @ECLASS-VARIABLE: XORG_PACKAGE_NAME
# @DESCRIPTION:
# For git checkout the git repository might differ from package name.
# This variable can be used for proper directory specification
: ${XORG_PACKAGE_NAME:=${PN}}

HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/${XORG_MODULE}${XORG_PACKAGE_NAME}"

# @ECLASS-VARIABLE: XORG_TARBALL_SUFFIX
# @DESCRIPTION:
# Most X11 projects provide tarballs as tar.bz2 or tar.xz. This eclass defaults
# to bz2.
: ${XORG_TARBALL_SUFFIX:="bz2"}

if [[ -n ${GIT_ECLASS} ]]; then
	: ${EGIT_REPO_URI:="https://gitlab.freedesktop.org/xorg/${XORG_MODULE}${XORG_PACKAGE_NAME}.git"}
elif [[ -n ${XORG_BASE_INDIVIDUAL_URI} ]]; then
	SRC_URI="${XORG_BASE_INDIVIDUAL_URI}/${XORG_MODULE}${P}.tar.${XORG_TARBALL_SUFFIX}"
fi

: ${SLOT:=0}

# Set the license for the package. This can be overridden by setting
# LICENSE after the inherit. Nearly all FreeDesktop-hosted X packages
# are under the MIT license. (This is what Red Hat does in their rpms)
: ${LICENSE:=MIT}

# Set up autotools shared dependencies
# Remember that all versions here MUST be stable
XORG_EAUTORECONF_ARCHES="ppc-aix x86-winnt"
EAUTORECONF_DEPEND+="
	>=sys-devel/libtool-2.2.6a
	sys-devel/m4"
if [[ ${PN} != util-macros ]] ; then
	EAUTORECONF_DEPEND+=" >=x11-misc/util-macros-1.18 >=media-fonts/font-util-1.2.0"
fi
WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
for arch in ${XORG_EAUTORECONF_ARCHES}; do
	EAUTORECONF_DEPENDS+=" ${arch}? ( ${EAUTORECONF_DEPEND} )"
done
unset arch
BDEPEND+=" ${EAUTORECONF_DEPENDS}"
[[ ${XORG_EAUTORECONF} != no ]] && BDEPEND+=" ${EAUTORECONF_DEPEND}"
unset EAUTORECONF_DEPENDS
unset EAUTORECONF_DEPEND

# @ECLASS-VARIABLE: XORG_STATIC
# @DESCRIPTION:
# Enables static-libs useflag. Set to no, if your package gets:
#
# QA: configure: WARNING: unrecognized options: --disable-static
: ${XORG_STATIC:="yes"}

# Add static-libs useflag where useful.
if [[ ${XORG_STATIC} == yes \
		&& ${CATEGORY} != app-doc \
		&& ${CATEGORY} != x11-apps \
		&& ${CATEGORY} != x11-drivers \
		&& ${CATEGORY} != media-fonts \
		&& ${PN} != util-macros \
		&& ${PN} != xbitmaps \
		&& ${PN} != xorg-cf-files \
		&& ${PN/xcursor} = ${PN} ]]; then
	IUSE+=" static-libs"
fi

if [[ ${XORG_MULTILIB} == yes ]]; then
	BDEPEND+=" virtual/pkgconfig[${MULTILIB_USEDEP}]"
else
	BDEPEND+=" virtual/pkgconfig"
fi

# @ECLASS-VARIABLE: XORG_DRI
# @DESCRIPTION:
# Possible values are "always" or the value of the useflag DRI capabilities
# are required for. Default value is "no"
#
# Eg. XORG_DRI="opengl" will pull all dri dependent deps for opengl useflag
: ${XORG_DRI:="no"}

DRI_COMMON_DEPEND="
	x11-base/xorg-server[-minimal]
	x11-libs/libdrm
"
case ${XORG_DRI} in
	no)
		;;
	always)
		COMMON_DEPEND+=" ${DRI_COMMON_DEPEND}"
		;;
	*)
		COMMON_DEPEND+=" ${XORG_DRI}? ( ${DRI_COMMON_DEPEND} )"
		IUSE+=" ${XORG_DRI}"
		;;
esac
unset DRI_COMMON_DEPEND

if [[ ${PN} == xf86-video-* || ${PN} == xf86-input-* ]]; then
	DEPEND+="  x11-base/xorg-proto"
	RDEPEND+=" x11-base/xorg-server:="
	COMMON_DEPEND+=" >=x11-base/xorg-server-1.20[xorg]"
	[[ ${PN} == xf86-video-* ]] && COMMON_DEPEND+=" >=x11-libs/libpciaccess-0.14"
fi


# @ECLASS-VARIABLE: XORG_DOC
# @DESCRIPTION:
# Possible values are "always" or the value of the useflag doc packages
# are required for. Default value is "no"
#
# Eg. XORG_DOC="manual" will pull all doc dependent deps for manual useflag
: ${XORG_DOC:="no"}

DOC_DEPEND="
	doc? (
		|| ( app-text/asciidoc dev-ruby/asciidoctor )
		app-text/xmlto
		app-doc/doxygen
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.3
	)
"
case ${XORG_DOC} in
	no)
		;;
	always)
		BDEPEND+=" ${DOC_DEPEND}"
		;;
	*)
		BDEPEND+=" ${XORG_DOC}? ( ${DOC_DEPEND} )"
		IUSE+=" ${XORG_DOC}"
		;;
esac
unset DOC_DEPEND

DEPEND+=" ${COMMON_DEPEND}"
RDEPEND+=" ${COMMON_DEPEND}"
unset COMMON_DEPEND

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND=${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND=${RDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: PDEPEND=${PDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: BDEPEND=${BDEPEND}"

# @FUNCTION: xorg-3_src_unpack
# @DESCRIPTION:
# Simply unpack source code.
xorg-3_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${GIT_ECLASS} ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

# @FUNCTION: xorg-3_reconf_source
# @DESCRIPTION:
# Run eautoreconf if necessary, and run elibtoolize.
xorg-3_reconf_source() {
	debug-print-function ${FUNCNAME} "$@"

	case ${CHOST} in
		*-aix* | *-winnt*)
			# some hosts need full eautoreconf
			[[ -e "./configure.ac" || -e "./configure.in" ]] \
				&& XORG_EAUTORECONF=yes
			;;
		*)
			# elibtoolize required for BSD
			[[ ${XORG_EAUTORECONF} != no && ( -e "./configure.ac" || -e "./configure.in" ) ]] \
				&& XORG_EAUTORECONF=yes
			;;
	esac

	[[ ${XORG_EAUTORECONF} != no ]] && eautoreconf
	elibtoolize --patch-only
}

# @FUNCTION: xorg-3_src_prepare
# @DESCRIPTION:
# Prepare a package after unpacking, performing all X-related tasks.
xorg-3_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	default
	xorg-3_reconf_source
}

# @FUNCTION: xorg-3_flags_setup
# @DESCRIPTION:
# Set up CFLAGS for a debug build
xorg-3_flags_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# Win32 require special define
	[[ ${CHOST} == *-winnt* ]] && append-cppflags -DWIN32 -D__STDC__
	# hardened ldflags
	[[ ${PN} == xorg-server || ${PN} == xf86-video-* || ${PN} == xf86-input-* ]] \
		&& append-ldflags -Wl,-z,lazy

	# Quite few libraries fail on runtime without these:
	if has static-libs ${IUSE//+}; then
		filter-flags -Wl,-Bdirect
		filter-ldflags -Bdirect
		filter-ldflags -Wl,-Bdirect
	fi
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf "${econfargs[@]}"
}

# @FUNCTION: xorg-3_src_configure
# @DESCRIPTION:
# Perform any necessary pre-configuration steps, then run configure
xorg-3_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	xorg-3_flags_setup

	# @VARIABLE: XORG_CONFIGURE_OPTIONS
	# @DESCRIPTION:
	# Array of an additional options to pass to configure.
	# @DEFAULT_UNSET
	local xorgconfadd=("${XORG_CONFIGURE_OPTIONS[@]}")

	# Check if package supports disabling of dep tracking
	# Fixes warnings like:
	#    WARNING: unrecognized options: --disable-dependency-tracking
	if grep -q -s "disable-depencency-tracking" ${ECONF_SOURCE:-.}/configure; then
		local dep_track="--disable-dependency-tracking"
	fi

	# Check if package supports disabling of selective -Werror=...
	if grep -q -s "disable-selective-werror" ${ECONF_SOURCE:-.}/configure; then
		local selective_werror="--disable-selective-werror"
	fi

	local econfargs=(
		${dep_track}
		${selective_werror}
		"${xorgconfadd[@]}"
	)

	# Handle static-libs found in IUSE, disable them by default
	if in_iuse static-libs; then
		econfargs+=(
			--enable-shared
			$(use_enable static-libs static)
		)
	fi

	if [[ ${XORG_MULTILIB} == yes ]]; then
		multilib-minimal_src_configure "$@"
	else
		econf "${econfargs[@]}" "$@"
	fi
}

multilib_src_compile() {
	emake "$@" || die 'emake failed'
}

# @FUNCTION: xorg-3_src_compile
# @DESCRIPTION:
# Compile a package, performing all X-related tasks.
xorg-3_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${XORG_MULTILIB} == yes ]]; then
		multilib-minimal_src_compile "$@"
	else
		emake "$@" || die 'emake failed'
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" "${install_args[@]}" "$@" install || die "emake install failed"
}

# @FUNCTION: xorg-3_src_install
# @DESCRIPTION:
# Install a built package to ${D}, performing any necessary steps.
xorg-3_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	local install_args=( docdir="${EPREFIX}/usr/share/doc/${PF}" )

	if [[ ${XORG_MULTILIB} == yes ]]; then
		multilib-minimal_src_install "$@"
	else
		emake DESTDIR="${D}" "${install_args[@]}" "$@" install || die "emake install failed"
	fi

	# Many X11 libraries unconditionally install developer documentation
	if [[ -d "${D}"/usr/share/man/man3 ]]; then
		! in_iuse doc && eqawarn "ebuild should set XORG_DOC=doc since package installs library documentation"
	fi

	if in_iuse doc && ! use doc; then
		rm -rf "${D}"/usr/share/man/man3
		rmdir "${D}"/usr{/share{/man,},} 2>/dev/null
	fi

	# Don't install libtool archives (even for modules)
	find "${D}" -type f -name '*.la' -delete || die
}
