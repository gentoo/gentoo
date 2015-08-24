# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

HOMEPAGE="http://www.coin3d.org/"
DESCRIPTION="GUI binding for using Coin/Open Inventor with Xt/Motif"
SRC_URI="https://bitbucket.org/Coin3D/coin/downloads/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="debug doc static-libs"

RDEPEND="
	>=media-libs/coin-3.1.3
	x11-libs/motif:0
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.0-pkgconfig-partial.patch"
)

DOCS=(AUTHORS ChangeLog HACKING NEWS README TODO BUGS.txt)

src_configure() {
	local myeconfargs=(
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		--disable-compact
		--disable-html-help
		--includedir="$(coin-config --includedir)"
		--with-coin
		--with-motif
		$(use_enable debug)
		$(use_enable debug profile)
		$(use_enable doc html)
		$(use_enable doc man)
	)
	autotools-utils_src_configure
	# Remove SoXt from Libs.private (patch installs it in Libs)
	sed -i -e '/Libs.private/s/ -lSoXt//' "${BUILD_DIR}"/SoXt.pc || die
	# Strip the default libdir
	sed -i -e "s,-L%{_libdir} ,," soxt-default.cfg
	# soxt-config is arch dependent
	sed -i -e "s,/share/Coin/conf/,/%{_lib}/Coin2/conf/,g" soxt-config
}
