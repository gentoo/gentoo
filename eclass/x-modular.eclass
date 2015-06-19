# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/x-modular.eclass,v 1.126 2013/07/05 17:39:10 ulm Exp $
#
# DEPRECATED
# This eclass has been superseded by xorg-2
# Please modify your ebuilds to use that instead
#
# @ECLASS: x-modular.eclass
# @MAINTAINER:
# Donnie Berkholz <dberkholz@gentoo.org>
# x11@gentoo.org
# @BLURB: Reduces code duplication in the modularized X11 ebuilds.
# @DESCRIPTION:
# This eclass makes trivial X ebuilds possible for apps, fonts, drivers,
# and more. Many things that would normally be done in various functions
# can be accessed by setting variables instead, such as patching,
# running eautoreconf, passing options to configure and installing docs.
#
# All you need to do in a basic ebuild is inherit this eclass and set
# DESCRIPTION, KEYWORDS and RDEPEND/DEPEND. If your package is hosted
# with the other X packages, you don't need to set SRC_URI. Pretty much
# everything else should be automatic.

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git"
	SNAPSHOT="yes"
	SRC_URI=""
fi

# If we're a font package, but not the font.alias one
FONT_ECLASS=""
if [[ "${PN/#font-}" != "${PN}" ]] \
	&& [[ "${CATEGORY}" = "media-fonts" ]] \
	&& [[ "${PN}" != "font-alias" ]] \
	&& [[ "${PN}" != "font-util" ]]; then
	# Activate font code in the rest of the eclass
	FONT="yes"

	# Whether to inherit the font eclass
	FONT_ECLASS="font"
fi

inherit eutils libtool multilib toolchain-funcs flag-o-matic autotools \
	${FONT_ECLASS} ${GIT_ECLASS}

EXPORTED_FUNCTIONS="src_unpack src_compile src_install pkg_preinst pkg_postinst pkg_postrm"

case "${EAPI:-0}" in
	0|1)
		;;
	2)
		EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS} src_prepare src_configure"
		;;
	*)
		die "Unknown EAPI ${EAPI}"
		;;
esac

# exports must be ALWAYS after inherit
EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

# @ECLASS-VARIABLE: XDIR
# @DESCRIPTION:
# Directory prefix to use for everything. If you want to install to a
# non-default prefix (e.g., /opt/xorg), change XDIR. This has not been
# recently tested. You may need to uncomment the setting of datadir and
# mandir in x-modular_src_install() or add it back in if it's no longer
# there. You may also want to change the SLOT.
XDIR="/usr"

IUSE=""
HOMEPAGE="http://xorg.freedesktop.org/"

# @ECLASS-VARIABLE: SNAPSHOT
# @DESCRIPTION:
# If set to 'yes' and configure.ac exists, eautoreconf will run. Set
# before inheriting this eclass.
: ${SNAPSHOT:=no}

# Set up SRC_URI for individual modular releases
BASE_INDIVIDUAL_URI="http://xorg.freedesktop.org/releases/individual"
# @ECLASS-VARIABLE: MODULE
# @DESCRIPTION:
# The subdirectory to download source from. Possible settings are app,
# doc, data, util, driver, font, lib, proto, xserver. Set above the
# inherit to override the default autoconfigured module.
if [[ -z ${MODULE} ]]; then
	case ${CATEGORY} in
		app-doc)             MODULE="doc"     ;;
		media-fonts)         MODULE="font"    ;;
		x11-apps|x11-wm)     MODULE="app"     ;;
		x11-misc|x11-themes) MODULE="util"    ;;
		x11-drivers)         MODULE="driver"  ;;
		x11-base)            MODULE="xserver" ;;
		x11-proto)           MODULE="proto"   ;;
		x11-libs)            MODULE="lib"     ;;
	esac
fi

if [[ -n ${GIT_ECLASS} ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/xorg/${MODULE}/${PN}"
else
	SRC_URI="${SRC_URI} ${BASE_INDIVIDUAL_URI}/${MODULE}/${P}.tar.bz2"
fi

SLOT="0"

# Set the license for the package. This can be overridden by setting
# LICENSE after the inherit. Nearly all FreeDesktop-hosted X packages
# are under the MIT license. (This is what Red Hat does in their rpms)
LICENSE="MIT"

# Set up shared dependencies
if [[ -n "${SNAPSHOT}" ]]; then
# FIXME: What's the minimal libtool version supporting arbitrary versioning?
	DEPEND="${DEPEND}
		>=sys-devel/libtool-1.5
		>=sys-devel/m4-1.4"
	WANT_AUTOCONF="latest"
	WANT_AUTOMAKE="latest"
fi

if [[ -n "${FONT}" ]]; then
	RDEPEND="${RDEPEND}
		media-fonts/encodings
		x11-apps/mkfontscale
		x11-apps/mkfontdir"
	PDEPEND="${PDEPEND}
		media-fonts/font-alias"

	# Starting with 7.0RC3, we can specify the font directory
	# But oddly, we can't do the same for encodings or font-alias

# @ECLASS-VARIABLE: FONT_DIR
# @DESCRIPTION:
# If you're creating a font package and the suffix of PN is not equal to
# the subdirectory of /usr/share/fonts/ it should install into, set
# FONT_DIR to that directory or directories. Set before inheriting this
# eclass.
	: ${FONT_DIR:=${PN##*-}}

	# Fix case of font directories
	FONT_DIR=${FONT_DIR/ttf/TTF}
	FONT_DIR=${FONT_DIR/otf/OTF}
	FONT_DIR=${FONT_DIR/type1/Type1}
	FONT_DIR=${FONT_DIR/speedo/Speedo}

	# Set up configure options, wrapped so ebuilds can override if need be
	if [[ -z ${FONT_OPTIONS} ]]; then
		FONT_OPTIONS="--with-fontdir=\"/usr/share/fonts/${FONT_DIR}\""
	fi

	if [[ -n "${FONT}" ]]; then
		if [[ ${PN##*-} = misc ]] || [[ ${PN##*-} = 75dpi ]] || [[ ${PN##*-} = 100dpi ]] || [[ ${PN##*-} = cyrillic ]]; then
			IUSE="${IUSE} nls"
		fi
	fi
fi

# If we're a driver package
if [[ "${PN/#xf86-video}" != "${PN}" ]] || [[ "${PN/#xf86-input}" != "${PN}" ]]; then
	# Enable driver code in the rest of the eclass
	DRIVER="yes"
fi

# Debugging -- ignore packages that can't be built with debugging
if [[ -z "${FONT}" ]] \
	&& [[ "${CATEGORY/app-doc}" = "${CATEGORY}" ]] \
	&& [[ "${CATEGORY/x11-proto}" = "${CATEGORY}" ]] \
	&& [[ "${PN/util-macros}" = "${PN}" ]] \
	&& [[ "${PN/xbitmaps}" = "${PN}" ]] \
	&& [[ "${PN/xkbdata}" = "${PN}" ]] \
	&& [[ "${PN/xorg-cf-files}" = "${PN}" ]] \
	&& [[ "${PN/xcursor}" = "${PN}" ]] \
	; then
	DEBUGGABLE="yes"
	IUSE="${IUSE} debug"
fi

DEPEND="${DEPEND}
	virtual/pkgconfig"

if [[ "${PN/util-macros}" = "${PN}" ]]; then
	DEPEND="${DEPEND}
		>=x11-misc/util-macros-1.3.0"
fi

RDEPEND="${RDEPEND}
	!<=x11-base/xorg-x11-6.9"
# Provides virtual/x11 for temporary use until packages are ported
#	x11-base/x11-env"

# @FUNCTION: x-modular_specs_check
# @USAGE:
# @DESCRIPTION:
# Make any necessary changes related to gcc specs (generally hardened)
x-modular_specs_check() {
	if [[ ${PN:0:11} = "xorg-server" ]] || [[ -n "${DRIVER}" ]]; then
		append-ldflags -Wl,-z,lazy
		# (#116698) breaks loading
		filter-ldflags -Wl,-z,now
	fi
}

# @FUNCTION: x-modular_dri_check
# @USAGE:
# @DESCRIPTION:
# Ensures the server supports DRI if building a driver with DRI support
x-modular_dri_check() {
	# (#120057) Enabling DRI in drivers requires that the server was built with
	# support for it
	# Starting with xorg-server 1.5.3, DRI support is always enabled unless
	# USE=minimal is set (see bug #252084)
	if [[ -n "${DRIVER}" ]]; then
		if has dri ${IUSE} && use dri; then
			einfo "Checking for direct rendering capabilities ..."
			if has_version '>=x11-base/xorg-server-1.5.3'; then
				if built_with_use x11-base/xorg-server minimal; then
					die "You must build x11-base/xorg-server with USE=-minimal."
				fi
			else
				if ! built_with_use x11-base/xorg-server dri; then
					die "You must build x11-base/xorg-server with USE=dri."
				fi
			fi
		fi
	fi
}

# @FUNCTION: x-modular_server_supports_drivers_check
# @USAGE:
# @DESCRIPTION:
# Ensures the server SDK is installed if a driver is being built
x-modular_server_supports_drivers_check() {
	# (#135873) Only certain servers will actually use or be capable of
	# building external drivers, including binary drivers.
	if [[ -n "${DRIVER}" ]]; then
		if has_version '>=x11-base/xorg-server-1.1'; then
			if ! built_with_use x11-base/xorg-server xorg; then
				eerror "x11-base/xorg-server is not built with support for external drivers."
				die "You must build x11-base/xorg-server with USE=xorg."
			fi
		fi
	fi
}

# @FUNCTION: x-modular_unpack_source
# @USAGE:
# @DESCRIPTION:
# Simply unpack source code. Nothing else.
x-modular_unpack_source() {
	if [[ -n ${GIT_ECLASS} ]]; then
		git_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"

	if [[ -n ${FONT_OPTIONS} ]]; then
		einfo "Detected font directory: ${FONT_DIR}"
	fi
}

# @FUNCTION: x-modular_patch_source
# @USAGE:
# @DESCRIPTION:
# Apply all patches
x-modular_patch_source() {
	# Use standardized names and locations with bulk patching
	# Patch directory is ${WORKDIR}/patch
	# See epatch() in eutils.eclass for more documentation
	if [[ -z "${EPATCH_SUFFIX}" ]] ; then
		EPATCH_SUFFIX="patch"
	fi

# @VARIABLE: PATCHES
# @DESCRIPTION:
# If you have any patches to apply, set PATCHES to their locations and epatch
# will apply them. It also handles epatch-style bulk patches, if you know how to
# use them and set the correct variables. If you don't, read eutils.eclass.
	if [[ ${#PATCHES[@]} -gt 1 ]]; then
		for x in "${PATCHES[@]}"; do
			epatch "${x}"
		done
	elif [[ -n "${PATCHES}" ]]; then
		for x in ${PATCHES}; do
			epatch "${x}"
		done
	# For non-default directory bulk patching
	elif [[ -n "${PATCH_LOC}" ]] ; then
		epatch ${PATCH_LOC}
	# For standard bulk patching
	elif [[ -d "${EPATCH_SOURCE}" ]] ; then
		epatch
	fi
}

# @FUNCTION: x-modular_reconf_source
# @USAGE:
# @DESCRIPTION:
# Run eautoreconf if necessary, and run elibtoolize.
x-modular_reconf_source() {
	if [[ "${SNAPSHOT}" = "yes" ]]
	then
		# If possible, generate configure if it doesn't exist
		if [ -f "./configure.ac" ]
		then
			eautoreconf
		fi
	fi

	# Joshua Baergen - October 23, 2005
	# Fix shared lib issues on MIPS, FBSD, etc etc
	elibtoolize
}

# @FUNCTION: x-modular_src_prepare
# @USAGE:
# @DESCRIPTION:
# Prepare a package after unpacking, performing all X-related tasks.
x-modular_src_prepare() {
	[[ -n ${GIT_ECLASS} ]] && has src_prepare ${EXPORTED_FUNCTIONS} \
		&& git_src_prepare
	x-modular_patch_source
	x-modular_reconf_source
}

# @FUNCTION: x-modular_src_unpack
# @USAGE:
# @DESCRIPTION:
# Unpack a package, performing all X-related tasks.
x-modular_src_unpack() {
	x-modular_specs_check
	x-modular_server_supports_drivers_check
	x-modular_dri_check
	x-modular_unpack_source
	has src_prepare ${EXPORTED_FUNCTIONS} || x-modular_src_prepare
}

# @FUNCTION: x-modular_font_configure
# @USAGE:
# @DESCRIPTION:
# If a font package, perform any necessary configuration steps
x-modular_font_configure() {
	if [[ -n "${FONT}" ]]; then
		# Might be worth adding an option to configure your desired font
		# and exclude all others. Also, should this USE be nls or minimal?
		if has nls ${IUSE//+} && ! use nls; then
			FONT_OPTIONS="${FONT_OPTIONS}
				--disable-iso8859-2
				--disable-iso8859-3
				--disable-iso8859-4
				--disable-iso8859-5
				--disable-iso8859-6
				--disable-iso8859-7
				--disable-iso8859-8
				--disable-iso8859-9
				--disable-iso8859-10
				--disable-iso8859-11
				--disable-iso8859-12
				--disable-iso8859-13
				--disable-iso8859-14
				--disable-iso8859-15
				--disable-iso8859-16
				--disable-jisx0201
				--disable-koi8-r"
		fi
	fi
}

# @FUNCTION: x-modular_debug_setup
# @USAGE:
# @DESCRIPTION:
# Set up CFLAGS for a debug build
x-modular_debug_setup() {
	if [[ -n "${DEBUGGABLE}" ]]; then
		if use debug; then
			strip-flags
			append-flags -g
		fi
	fi
}

# @FUNCTION: x-modular_src_configure
# @USAGE:
# @DESCRIPTION:
# Perform any necessary pre-configuration steps, then run configure
x-modular_src_configure() {
	x-modular_font_configure
	x-modular_debug_setup

# @VARIABLE: CONFIGURE_OPTIONS
# @DESCRIPTION:
# Any extra options to pass to configure

	# If prefix isn't set here, .pc files cause problems
	if [[ -x ${ECONF_SOURCE:-.}/configure ]]; then
		econf --prefix=${XDIR} \
			--datadir=${XDIR}/share \
			${FONT_OPTIONS} \
			${DRIVER_OPTIONS} \
			${CONFIGURE_OPTIONS}
	fi
}

# @FUNCTION: x-modular_src_make
# @USAGE:
# @DESCRIPTION:
# Run make.
x-modular_src_make() {
	emake || die "emake failed"
}

# @FUNCTION: x-modular_src_compile
# @USAGE:
# @DESCRIPTION:
# Compile a package, performing all X-related tasks.
x-modular_src_compile() {
	has src_configure ${EXPORTED_FUNCTIONS} || x-modular_src_configure
	x-modular_src_make
}

# @FUNCTION: x-modular_src_install
# @USAGE:
# @DESCRIPTION:
# Install a built package to ${D}, performing any necessary steps.
# Creates a ChangeLog from git if using live ebuilds.
x-modular_src_install() {
	# Install everything to ${XDIR}
	if [[ ${CATEGORY} = x11-proto ]]; then
		make \
			${PN/proto/}docdir=/usr/share/doc/${PF} \
			DESTDIR="${D}" \
			install \
			|| die
	else
		make \
			docdir=/usr/share/doc/${PF} \
			DESTDIR="${D}" \
			install \
			|| die
	fi
# Shouldn't be necessary in XDIR=/usr
# einstall forces datadir, so we need to re-force it
#		datadir=${XDIR}/share \
#		mandir=${XDIR}/share/man \

	if [[ -n ${GIT_ECLASS} ]]; then
		pushd "${EGIT_STORE_DIR}/${EGIT_CLONE_DIR}"
		git log ${GIT_TREE} > "${S}"/ChangeLog
		popd
	fi

	if [[ -e ${S}/ChangeLog ]]; then
		dodoc "${S}"/ChangeLog
	fi
# @VARIABLE: DOCS
# @DESCRIPTION:
# Any documentation to install via dodoc
	[[ -n ${DOCS} ]] && dodoc ${DOCS}

	# Don't install libtool archives for server modules
	if [[ -e ${D}/usr/$(get_libdir)/xorg/modules ]]; then
		find "${D}"/usr/$(get_libdir)/xorg/modules -name '*.la' \
			| xargs rm -f
	fi

	if [[ -n "${FONT}" ]]; then
		remove_font_metadata
	fi

	if [[ -n "${DRIVER}" ]]; then
		install_driver_hwdata
	fi
}

# @FUNCTION: x-modular_pkg_preinst
# @USAGE:
# @DESCRIPTION:
# This function doesn't do anything right now, but it may in the future.
x-modular_pkg_preinst() {
	# We no longer do anything here, but we can't remove it from the API
	:
}

# @FUNCTION: x-modular_pkg_postinst
# @USAGE:
# @DESCRIPTION:
# Run X-specific post-installation tasks on the live filesystem. The
# only task right now is some setup for font packages.
x-modular_pkg_postinst() {
	if [[ -n "${FONT}" ]]; then
		setup_fonts
	fi
}

# @FUNCTION: x-modular_pkg_postrm
# @USAGE:
# @DESCRIPTION:
# Run X-specific post-removal tasks on the live filesystem. The only
# task right now is some cleanup for font packages.
x-modular_pkg_postrm() {
	if [[ -n "${FONT}" ]]; then
		font_pkg_postrm
	fi
}

# @FUNCTION: setup_fonts
# @USAGE:
# @DESCRIPTION:
# Generates needed files for fonts and fixes font permissions
setup_fonts() {
	if [[ ! -n "${FONT_DIR}" ]]; then
		msg="FONT_DIR is empty. The ebuild should set it to at least one subdir of /usr/share/fonts."
		eerror "${msg}"
		die "${msg}"
	fi

	create_fonts_scale
	create_fonts_dir
	create_font_cache
}

# @FUNCTION: remove_font_metadata
# @USAGE:
# @DESCRIPTION:
# Don't let the package install generated font files that may overlap
# with other packages. Instead, they're generated in pkg_postinst().
remove_font_metadata() {
	local DIR
	for DIR in ${FONT_DIR}; do
		if [[ "${DIR}" != "Speedo" ]] && \
			[[ "${DIR}" != "CID" ]] ; then
			# Delete font metadata files
			# fonts.scale, fonts.dir, fonts.cache-1
			rm -f "${D}"/usr/share/fonts/${DIR}/fonts.{scale,dir,cache-1}
		fi
	done
}

# @FUNCTION: install_driver_hwdata
# @USAGE:
# @DESCRIPTION:
# Installs device-to-driver mappings for system-config-display and
# anything else that uses hwdata.
install_driver_hwdata() {
	insinto /usr/share/hwdata/videoaliases
	for i in "${FILESDIR}"/*.xinf; do
		# We need this for the case when none exist,
		# so *.xinf doesn't expand
		if [[ -e $i ]]; then
			doins $i
		fi
	done
}

# @FUNCTION: discover_font_dirs
# @USAGE:
# @DESCRIPTION:
# Deprecated. Sets up the now-unused FONT_DIRS variable.
discover_font_dirs() {
	FONT_DIRS="${FONT_DIR}"
}

# @FUNCTION: create_fonts_scale
# @USAGE:
# @DESCRIPTION:
# Create fonts.scale file, used by the old server-side fonts subsystem.
create_fonts_scale() {
	ebegin "Creating fonts.scale files"
		local x
		for DIR in ${FONT_DIR}; do
			x=${ROOT}/usr/share/fonts/${DIR}
			[[ -z "$(ls ${x}/)" ]] && continue
			[[ "$(ls ${x}/)" = "fonts.cache-1" ]] && continue

			# Only generate .scale files if truetype, opentype or type1
			# fonts are present ...

			# NOTE: There is no way to regenerate Speedo/CID fonts.scale
			# <dberkholz@gentoo.org> 2 August 2004
			if [[ "${x/encodings}" = "${x}" ]] \
				&& [[ -n "$(find ${x} -iname '*.[pot][ft][abcf]' -print)" ]]; then
				mkfontscale \
					-a "${ROOT}"/usr/share/fonts/encodings/encodings.dir \
					-- ${x}
			fi
		done
	eend 0
}

# @FUNCTION: create_fonts_dir
# @USAGE:
# @DESCRIPTION:
# Create fonts.dir file, used by the old server-side fonts subsystem.
create_fonts_dir() {
	ebegin "Generating fonts.dir files"
		for DIR in ${FONT_DIR}; do
			x=${ROOT}/usr/share/fonts/${DIR}
			[[ -z "$(ls ${x}/)" ]] && continue
			[[ "$(ls ${x}/)" = "fonts.cache-1" ]] && continue

			if [[ "${x/encodings}" = "${x}" ]]; then
				mkfontdir \
					-e "${ROOT}"/usr/share/fonts/encodings \
					-e "${ROOT}"/usr/share/fonts/encodings/large \
					-- ${x}
			fi
		done
	eend 0
}

# @FUNCTION: create_font_cache
# @USAGE:
# @DESCRIPTION:
# Create fonts.cache-1 files, used by the new client-side fonts
# subsystem.
create_font_cache() {
	font_pkg_postinst
}
