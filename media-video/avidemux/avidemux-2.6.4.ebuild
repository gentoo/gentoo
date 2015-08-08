# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"
inherit cmake-utils eutils flag-o-matic l10n toolchain-funcs

SLOT="2.6"
MY_P="${PN}_${PV}"

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/${PN}"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.gz"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl nls qt4 sdl vdpau xv"

DEPEND="~media-libs/avidemux-core-${PV}[nls?,sdl?,vdpau?,xv?]
	opengl? ( virtual/opengl )
	qt4? ( >=dev-qt/qtgui-4.8.3:4 )"
RDEPEND="$DEPEND"
PDEPEND="~media-libs/avidemux-plugins-${PV}"

S="${WORKDIR}/${MY_P}"

processes="buildCli:avidemux/cli"

use qt4 && processes+=" buildQt4:avidemux/qt4"

src_prepare() {
	default

	# Fix icon name -> avidemux-2.6.png
	sed -i -e "/^Icon/ s:${PN}:${PN}-2.6:" ${PN}2.desktop || die "Icon name fix failed."

	# The desktop file is broken. It uses avidemux2 instead of avidemux3
	# so it will actually launch avidemux-2.5 if it is installed.
	sed -i -e "/^Exec/ s:${PN}2:${PN}3:" ${PN}2.desktop || die "Desktop file fix failed."

	# Now rename the desktop file to not collide with 2.5.
	mv ${PN}2.desktop ${PN}-2.6.desktop || die "Collision rename failed."

	# The desktop file is broken. It uses avidemux2 instead of avidemux3
	# so it will actually launch avidemux-2.5 if it is installed.
	sed -i -re '/^Exec/ s:(avidemux3_)gtk:\1qt4:' ${PN}-2.6.desktop || die "Desktop file fix failed."

	# Fix QA warnings that complain a trailing ; is missing and Application is deprecated.
	sed -i -e 's/Application;AudioVideo/AudioVideo;/g' ${PN}-2.6.desktop
}

src_configure() {
	local mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DCMAKE_INSTALL_PREFIX='/usr'
		$(cmake-utils_use nls GETTEXT)
		$(cmake-utils_use sdl SDL)
		$(cmake-utils_use vdpau VDPAU)
		$(cmake-utils_use xv XVIDEO)
	"

	if use debug ; then
		mycmakeargs+=" -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug"
	fi

	for process in ${processes} ; do
		local build="${process%%:*}"

		mkdir "${S}"/${build} || die "Can't create build folder."
		cd "${S}"/${build} || die "Can't enter build folder."
		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		local source="${process%%:*}"

		cd "${S}/${source}" || die "Can't enter build folder."
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	done
}

src_install() {
	for process in ${processes} ; do
		local source="${process%%:*}"

		cd "${S}/${source}" || die "Can't enter build folder."
		emake DESTDIR="${ED}" install
	done

	cd "${S}" || die "Can't enter source folder."

	if [[ -f "${ED}"/usr/bin/avidemux3_cli ]] ; then
		fperms +x /usr/bin/avidemux3_cli
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs ]] ; then
		fperms +x /usr/bin/avidemux3_jobs
	fi
	use qt4 && fperms +x /usr/bin/avidemux3_qt4

	newicon ${PN}_icon.png ${PN}-2.6.png
	use qt4 && domenu ${PN}-2.6.desktop

	dodoc AUTHORS README
}
