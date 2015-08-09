# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"
DISTUTILS_SINGLE_IMPL="1"

inherit eutils python-single-r1 distutils-r1 games

MY_PN=PySolFC
SOL_URI="mirror://sourceforge/${PN}"

DESCRIPTION="An exciting collection of more than 1000 solitaire card games"
HOMEPAGE="http://pysolfc.sourceforge.net/"
SRC_URI="${SOL_URI}/${MY_PN}-${PV}.tar.bz2
	extra-cardsets? ( ${SOL_URI}/${MY_PN}-Cardsets-${PV}.tar.bz2 )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="extra-cardsets minimal +sound"

S=${WORKDIR}/${MY_PN}-${PV}

DEPEND=""
RDEPEND="${RDEPEND}
	sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
	!minimal? ( dev-python/pillow[tk,${PYTHON_USEDEP}]
		dev-tcltk/tktable )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-PIL-imports.patch" #471514
		"${FILESDIR}"/${P}-gentoo.patch
	)

	distutils-r1_python_prepare_all
}

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare

	sed -i \
		-e "/pysol.desktop/d" \
		-e "s:share/icons:share/pixmaps:" \
		-e "s:data_dir =.*:data_dir = \'${GAMES_DATADIR}/${PN}\':" \
		setup.py || die

	sed -i \
		-e "s:@GAMES_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		pysollib/settings.py || die "fixing settings"

	mv docs/README{,.txt}
}

src_compile() {
	distutils-r1_src_compile
}

python_install_all() {
	make_desktop_entry pysol.py "PySol Fan Club Edition" pysol02

	if use extra-cardsets; then
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r "${WORKDIR}"/${MY_PN}-Cardsets-${PV}/*
	fi

	doman docs/*.6

	DOCS=( README AUTHORS docs/README.txt docs/README.SOURCE )
	HTML_DOCS=( docs/*html )

	distutils-r1_python_install_all

	dodir "${GAMES_BINDIR}"

	mv "${D}"/usr/bin/pysol.py "${D}""${GAMES_BINDIR}"/

	prepgamesdirs
}

src_install() {
	distutils-r1_src_install
}
