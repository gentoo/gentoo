# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MY_PN="melons"
DESCRIPTION="A thrilling watermelon bouncing game"
HOMEPAGE="http://www.imitationpickles.org/melons/index.html"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.tgz"
# No version upstream
#SRC_URI="http://www.imitationpickles.org/${MY_PN}/${MY_PN}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND=${DEPEND}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${MY_PN}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:melons.hs:${GAMES_STATEDIR}/${PN}/&:" \
		main.py || die

	cat <<-EOF > "${PN}" || die
	#!/bin/bash
	cd "${GAMES_DATADIR}/${PN}"
	exec ${EPYTHON} main.py
EOF
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data pgu const.py game.py main.py melon.py melons.py menu.py trampoline.py
	python_optimize "${D}${GAMES_DATADIR}/${PN}"
	dodoc *.txt
	dodir "${GAMES_STATEDIR}/${PN}"
	touch "${D}${GAMES_STATEDIR}"/${PN}/melons.hs
	fperms 664 "${GAMES_STATEDIR}"/${PN}/melons.hs
	newicon data/mellon0013.png "${PN}.png"
	make_desktop_entry ${PN} Watermelons
	prepgamesdirs
}
