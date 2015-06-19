# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/bub-n-bros/bub-n-bros-1.6.2.ebuild,v 1.5 2015/02/21 12:20:44 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MY_P=${P/-n-}
DESCRIPTION="A multiplayer clone of the famous Bubble Bobble game"
HOMEPAGE="http://bub-n-bros.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="MIT Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND=${DEPEND}

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	ecvs_clean
	epatch "${FILESDIR}"/${P}-home.patch
	python_fix_shebang .
}

src_compile() {
	# Compile the "statesaver" extension module to enable the Clock bonus
	cd "${S}"/bubbob
	${EPYTHON} setup.py build_ext -i || die

	# Compile the extension module required for the X Window client
	cd "${S}"/display
	${EPYTHON} setup.py build_ext -i || die

	# Build images
	cd "${S}"/bubbob/images
	${EPYTHON} buildcolors.py || die
}

src_install() {
	local dir=$(games_get_libdir)/${PN}

	exeinto "${dir}"
	doexe *.py

	insinto "${dir}"
	doins -r bubbob common display java http2 metaserver

	dodir "${GAMES_BINDIR}"
	dosym "${dir}"/BubBob.py "${GAMES_BINDIR}"/bubnbros

	python_optimize "${D}${dir}"

	newicon http2/data/bob.png ${PN}.png
	make_desktop_entry bubnbros Bub-n-Bros

	prepgamesdirs
}
