# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/singularity/singularity-0.30c-r1.ebuild,v 1.6 2015/02/10 10:04:21 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MUSIC=endgame-${PN}-music-006
DESCRIPTION="A simulation of a true AI. Go from computer to computer, pursued by the entire world"
HOMEPAGE="http://www.emhsoft.com/singularity/"
SRC_URI="http://endgame-singularity.googlecode.com/files/${P}-src.tar.gz
	music? ( http://endgame-singularity.googlecode.com/files/${MUSIC}.zip )"

LICENSE="GPL-2 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+music"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/sdl-mixer[vorbis]"
DEPEND="${DEPEND}
	app-arch/unzip"

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	rm -f code/{,*}/*.pyc data/*.html || die # Remove unecessary files
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r code data ${PN}.py || die
	python_optimize "${ED%/}/${GAMES_DATADIR}"/${PN}

	if use music ; then
		doins -r ../${MUSIC}/music || die
	fi
	games_make_wrapper ${PN} "${EPYTHON} ${PN}.py" "${GAMES_DATADIR}/${PN}"
	dodoc README.txt TODO Changelog AUTHORS
	prepgamesdirs
}
