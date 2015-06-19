# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/avidemux-plugins/avidemux-plugins-2.6.2-r2.ebuild,v 1.4 2015/01/29 17:25:10 mgorny Exp $

EAPI="5"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"
inherit cmake-utils eutils flag-o-matic l10n toolchain-funcs

SLOT="2.6"
MY_PN="${PN/-plugins/}"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Plugins for avidemux; a video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"
SRC_URI="mirror://sourceforge/${MY_PN}/${PV}/${MY_P}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="aften a52 alsa amr debug dts fontconfig jack lame libsamplerate cpu_flags_x86_mmx oss nls qt4 sdl vorbis truetype xvid x264 xv"

# TODO: Figure out which dependencies can be moved out of avidemux-core and avidemux into here.
RDEPEND="=media-video/avidemux-${PV}-r1"
DEPEND="$RDEPEND"

S="${WORKDIR}/${MY_P}"

PROCESSES="buildPluginsCommon:avidemux_plugins
	buildPluginsCLI:avidemux_plugins"

use qt4 && PROCESSES+=" buildPluginsQt4:avidemux_plugins"

src_configure() {
	local x mycmakeargs plugin_ui

	mycmakeargs="
		$(for x in ${IUSE}; do cmake-utils_use ${x/#-/}; done)
		$(cmake-utils_use amr OPENCORE_AMRWB)
		$(cmake-utils_use amr OPENCORE_AMRNB)
		$(cmake-utils_use dts LIBDCA)
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use truetype FREETYPE2)
		$(cmake-utils_use xv XVIDEO)
	"
	use debug && POSTFIX="_debug" && mycmakeargs+="-DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug"

	for PROCESS in ${PROCESSES} ; do
		SOURCE="${PROCESS%%:*}"
		DEST="${PROCESS#*:}"

		mkdir "${S}"/${SOURCE} || die "Can't create build folder."
		cd "${S}"/${SOURCE} || die "Can't enter build folder."

		if [[ "${SOURCE}" == "buildPluginsCommon" ]] ; then
			plugin_ui="-DPLUGIN_UI=COMMON"
		elif [[ "${SOURCE}" == "buildPluginsCLI" ]] ; then
			plugin_ui="-DPLUGIN_UI=CLI"
		elif [[ "${SOURCE}" == "buildPluginsQt4" ]] ; then
			plugin_ui="-DPLUGIN_UI=QT4"
		fi

		cmake -DAVIDEMUX_SOURCE_DIR="${S}" \
			-DCMAKE_INSTALL_PREFIX="/usr" \
			${mycmakeargs} ${plugin_ui} -G "Unix Makefiles" ../"${DEST}${POSTFIX}/" || die "cmake failed."
	done
}

src_compile() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for PROCESS in ${PROCESSES} ; do
		SOURCE="${PROCESS%%:*}"

		cd "${S}/${SOURCE}" || die "Can't enter build folder."
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	done
}

src_install() {
	for PROCESS in ${PROCESSES} ; do
		SOURCE="${PROCESS%%:*}"

		cd "${S}/${SOURCE}" || die "Can't enter build folder."
		emake DESTDIR="${ED}" install
	done
}
