# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

MUSIC=endgame-${PN}-music-006
DESCRIPTION="A simulation of a true AI. Go from computer to computer, pursued by the entire world"
HOMEPAGE="http://www.emhsoft.com/singularity/"
SRC_URI="https://endgame-singularity.googlecode.com/files/${P}-src.tar.gz
	music? ( https://endgame-singularity.googlecode.com/files/${MUSIC}.zip )"

LICENSE="GPL-2 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+music"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	media-libs/sdl-mixer[vorbis]"
DEPEND="${DEPEND}
	app-arch/unzip"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	rm -f code/{,*}/*.pyc data/*.html || die # Remove unecessary files
}

src_install() {
	insinto /usr/share/${PN}
	doins -r code data ${PN}.py || die
	python_optimize ${ED%/}/usr/share/${PN}

	if use music ; then
		doins -r ../${MUSIC}/music || die
	fi

	make_wrapper ${PN} "${EPYTHON} ${PN}.py" /usr/share/${PN}
	dodoc README.txt TODO Changelog AUTHORS
}
