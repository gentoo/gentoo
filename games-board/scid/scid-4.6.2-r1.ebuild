# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils toolchain-funcs gnome2-utils python-any-r1

DESCRIPTION="a free chess database application"
HOMEPAGE="http://scid.sourceforge.net/"
SRC_URI="mirror://sourceforge/scid/${P}.zip
	mirror://sourceforge/scid/spelling.zip
	mirror://sourceforge/scid/ratings.zip
	mirror://sourceforge/scid/photos.zip
	mirror://sourceforge/scid/scidlet40k.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-lang/tk:0
	dev-tcltk/tkimg
	>=sys-libs/zlib-1.1.3"
RDEPEND="${CDEPEND}
	!games-board/chessdb"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	app-arch/unzip"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	default
	mv scid-src ${P} || die
}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	edos2unix engines/togaII1.2.1a/src/Makefile
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		tcl/start.tcl || die
	sed -i \
		-e "/COMPILE.*testzlib/s:\$var(COMPILE):$(tc-getCXX):" \
		configure || die
	gzip ../ratings.ssp || die
	python_fix_shebang .
}

src_configure() {
	# configure is not an autotools script
	./configure \
		COMPILE="$(tc-getCXX)" \
		LINK="$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS}" \
		CC="$(tc-getCC)" \
		OPTIMIZE="${CXXFLAGS}" \
		TCL_INCLUDE="" \
		BINDIR="/usr/bin" \
		SHAREDIR="/usr/share/${PN}" || die
}

src_compile() {
	emake all_scid
}

src_install() {
	emake DESTDIR="${D}" install_scid
	insinto /usr/share/${PN}
	doins -r sounds

	dodoc ChangeLog TODO help/*.html

	newicon -s scalable svg/scid_app.svg ${PN}.svg
	make_desktop_entry scid Scid

	doins ../spelling.ssp ../ratings.ssp.gz ../*.spf
	newins ../scidlet40k.sbk scidlet.sbk
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "To enable speech, emerge dev-tcltk/snack"
	elog "To enable Xfcc support, emerge dev-tcltk/tdom"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
