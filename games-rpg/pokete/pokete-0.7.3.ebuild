# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit desktop python-single-r1 xdg

DESCRIPTION="Terminal-based clone of the game Pokémon"
HOMEPAGE="https://github.com/lxgr-linux/pokete"
SRC_URI="https://github.com/lxgr-linux/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=games-engines/scrap-engine-1.2.0[${PYTHON_USEDEP}]
		!kernel_linux? ( >=dev-python/pynput-1.7.6[${PYTHON_USEDEP}] )
	')
"

DIR="/usr/share/${PN}"

src_install() {
	exeinto "${DIR}"
	insinto "${DIR}"

	doins -r \
		mods/ \
		${PN}_classes/ \
		${PN}_data/ \
		${PN}_general_use_fns.py \
		release.py

	python_fix_shebang ${PN}.py
	doexe ${PN}.py
	dosym "${DIR/\/usr/..}"/${PN}.py /usr/bin/${PN}

	doicon -s scalable assets/${PN}.svg
	make_desktop_entry ${PN} Pokete "" "" Terminal=true

	dodoc *.md
}
