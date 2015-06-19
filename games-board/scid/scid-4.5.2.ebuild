# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/scid/scid-4.5.2.ebuild,v 1.5 2015/06/02 04:00:07 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils toolchain-funcs gnome2-utils python-any-r1 games

DESCRIPTION="a free chess database application"
HOMEPAGE="http://scid.sourceforge.net/"
SRC_URI="mirror://sourceforge/scid/Scid-${PV}.zip
	mirror://sourceforge/scid/spelling.zip
	mirror://sourceforge/scid/ratings.zip
	mirror://sourceforge/scid/photos.zip
	mirror://sourceforge/scid/scidlet40k.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

CDEPEND="dev-lang/tk:0
	>=sys-libs/zlib-1.1.3"
RDEPEND="${CDEPEND}
	!games-board/chessdb"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	app-arch/unzip"

pkg_setup() {
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_unpack() {
	default
	mv scid-code-* ${P} || die
}

src_prepare() {
	edos2unix engines/togaII1.2.1a/src/Makefile
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		tcl/start.tcl \
		src/scidlet.cpp \
		|| die "sed failed"
	gzip ../ratings.ssp
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
		BINDIR="${GAMES_BINDIR}" \
		SHAREDIR="${GAMES_DATADIR}/${PN}" \
		|| die "configure failed"
}

src_compile() {
	emake all_scid
}

src_install() {
	emake DESTDIR="${D}" install_scid
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r sounds

	dodoc ChangeLog TODO
	dohtml help/*.html

	newicon -s scalable svg/scid_app.svg ${PN}.svg
	make_desktop_entry scid Scid

	cd .. || die
	doins spelling.ssp ratings.ssp.gz *.spf
	newins scidlet40k.sbk scidlet.sbk

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	elog "To enable speech, emerge dev-tcltk/snack"
	elog "To enable some piece sets, emerge dev-tcltk/tkimg"
	elog "To enable Xfcc support, emerge dev-tcltk/tdom"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
