# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/qtoctave/qtoctave-0.10.1-r1.ebuild,v 1.4 2015/04/19 09:31:39 pacho Exp $

EAPI=5

inherit cmake-utils multilib

PID=2054

DESCRIPTION="Qt4 front-end for Octave"
HOMEPAGE="http://forja.rediris.es/projects/csl-qtoctave/"
SRC_URI="http://forja.rediris.es/frs/download.php/${PID}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
	|| ( ( >=dev-qt/qtgui-4.8.5:4 dev-qt/designer:4 ) <dev-qt/qtgui-4.8.5:4 )
	>=dev-qt/qtsvg-4.6:4"
RDEPEND="${CDEPEND}
	sci-mathematics/octave"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

DOCS=(readme.txt leeme.txt)

PATCHES=(
	"${FILESDIR}"/${P}-build-out-of-source.patch
	"${FILESDIR}"/${P}-build-widgetserver.patch
	"${FILESDIR}"/${P}-doc-path.patch
	"${FILESDIR}"/${P}-filedialog-filters.patch
	"${FILESDIR}"/${P}-initial_position.patch
	"${FILESDIR}"/${P}-no-native-menubars.patch
	"${FILESDIR}"/${P}-qtinfo-octave3.4.patch
	"${FILESDIR}"/${P}-use_octave_htmldoc.patch
	"${FILESDIR}"/${P}-desktop-file.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RPATH=ON
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}
