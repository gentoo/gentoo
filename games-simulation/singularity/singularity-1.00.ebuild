# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1

inherit desktop distutils-r1

MUSIC="endgame-${PN}-music-007"
DESCRIPTION="Simulation of a true AI. Go from computer to computer, chased by the whole world"
HOMEPAGE="http://www.emhsoft.com/singularity/ https://github.com/singularity/singularity"
SRC_URI="https://github.com/singularity/singularity/releases/download/v${PV}/${P/_alpha/a}.tar.gz"
SRC_URI+=" https://emhsoft.com/singularity/${MUSIC}.zip"
S="${WORKDIR}/${P/_alpha/a}"

LICENSE="GPL-2 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="app-arch/unzip"
DEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
		dev-python/polib[${PYTHON_USEDEP}]
	')
"
# sdl-mixer is used at runtime (through pygame)
# bug #731702
RDEPEND="
	${DEPEND}
	media-libs/sdl-mixer[vorbis,wav]
	!sys-cluster/singularity
"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PN}/${PN}/music
	doins "${WORKDIR}"/${MUSIC}/*

	dodoc README.txt TODO

	domenu ${PN}.desktop
	newicon ${PN}/data/themes/default/images/icon.png ${PN}.png
}
