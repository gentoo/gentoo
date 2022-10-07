# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{8..10} )
inherit desktop distutils-r1

SINGULARITY_MUSIC="endgame-${PN}-music-007"

DESCRIPTION="Simulation of a true AI. Go from computer to computer, chased by the whole world"
HOMEPAGE="http://www.emhsoft.com/singularity/"
SRC_URI="
	https://github.com/singularity/singularity/releases/download/v${PV}/${P}.tar.gz
	https://emhsoft.com/singularity/${SINGULARITY_MUSIC}.zip"

LICENSE="GPL-2+ BitstreamVera CC0-1.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/polib[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP}]
	')
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[vorbis]
	!app-containers/apptainer
	!sys-cluster/singularity"
BDEPEND="app-arch/unzip"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_install() {
	local DOCS=( AUTHORS.txt Changelog.txt README.txt TODO )
	distutils-r1_src_install

	python_moduleinto ${PN}/music
	python_domodule ../${SINGULARITY_MUSIC}/.

	newicon ${PN}/data/themes/default/images/icon.png ${PN}.png
	domenu ${PN}.desktop
}
