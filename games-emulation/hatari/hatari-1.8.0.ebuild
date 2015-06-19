# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/hatari/hatari-1.8.0.ebuild,v 1.5 2015/02/25 15:53:04 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils toolchain-funcs cmake-utils python-single-r1 games

DESCRIPTION="Atari ST emulator"
HOMEPAGE="http://hatari.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/hatari/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	media-libs/libsdl[X,sound,video]
	sys-libs/readline:0
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	dev-python/pygtk[${PYTHON_USEDEP}]
	games-emulation/emutos"

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-gentoo-docdir.patch
	# build with newer zlib (bug #387829)
	sed -i -e '1i#define OF(x) x' src/includes/unzip.h || die
	sed -i -e '/Encoding/d' ./python-ui/hatariui.desktop || die
	sed -i -e "s/python/${EPYTHON}/" tools/atari-hd-image.sh || die
	sed -i \
		-e "s%conf=.*$%conf=\"${GAMES_SYSCONFDIR}\"%" \
		-e "s%path=.*$%path=\"${GAMES_DATADIR}/${PN}/hatariui\"%" \
		python-ui/hatariui || die
	sed -i -e "s#@DOCDIR@#/usr/share/doc/${PF}/html/#" python-ui/uihelpers.py || die
	rm -f doc/CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DCMAKE_BUILD_TYPE:STRING=Release"
		"-DDATADIR=${GAMES_DATADIR}/${PN}"
		"-DBIN2DATADIR=${GAMES_DATADIR}/${PN}"
		"-DBINDIR=${GAMES_BINDIR}"
		"-DICONDIR=/usr/share/pixmaps"
		"-DDESKTOPDIR=/usr/share/applications"
		"-DMANDIR=/usr/share/man/man1"
		"-DDOCDIR=/usr/share/doc/${PF}"
		)
	cmake-utils_src_configure
}

src_install() {
	DOCS="readme.txt doc/*.txt" cmake-utils_src_install
	dohtml -r doc/
	python_fix_shebang "${ED%/}"/usr/share/games/hatari/{hatariui,hconsole}/
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "You need a TOS ROM to run hatari. EmuTOS, a free TOS implementation,"
	elog "has been installed in $(games_get_libdir) with a .img extension (there"
	elog "are several from which to choose)."
	elog
	elog "Another option is to go to http://www.atari.st/ and get a real TOS:"
	elog "  http://www.atari.st/"
	elog
	elog "The first time you run hatari, you should configure it to find the"
	elog "TOS you prefer to use.  Be sure to save your settings."
	echo
}
