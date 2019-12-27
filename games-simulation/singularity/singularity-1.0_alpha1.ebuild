# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop eutils python-single-r1

MUSIC="endgame-${PN}-music-007"
DESCRIPTION="Simulation of a true AI. Go from computer to computer, chased by the whole world"
HOMEPAGE="http://www.emhsoft.com/singularity/ https://github.com/singularity/singularity"
SRC_URI="https://github.com/singularity/singularity/releases/download/${P/_alpha/a}/${P/_alpha/a}.tar.gz
	http://emhsoft.com/singularity/${MUSIC}.zip"

LICENSE="GPL-2 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/polib[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${P/_alpha/a}"

src_install() {
	insinto /usr/share/${PN}
	doins -r "${PN}" "${PN}.py"

	python_optimize "${ED}/usr/share/${PN}"

	insinto /usr/share/${PN}/${PN}/music
	doins "${WORKDIR}"/${MUSIC}/*

	make_wrapper ${PN} "${EPYTHON} ${PN}.py" /usr/share/${PN}
	dodoc README.txt TODO Changelog AUTHORS

	domenu "${PN}.desktop"
	newicon "${PN}"/data/themes/default/images/icon.png "${PN}.png"
}
