# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Connect-4 game, single or network multiplayer"
HOMEPAGE="http://forcedattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/forcedattack/4stAttack-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"

S="${WORKDIR}/4stAttack-${PV}"

src_prepare() {
	default

	# move the doc files aside so it's easier to install the game files
	mv README.txt credits.txt changelog.txt ..
	rm -f GPL version~

	# This patch makes the game save settings in $HOME
	eapply "${FILESDIR}"/${P}-gentoo.diff
}

src_install() {
	make_wrapper ${PN} "python2 ${PN}.py" /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r *
	newicon kde/icons/64x64/forcedattack2.png ${PN}.png
	make_desktop_entry ${PN} "4st Attack 2"
	dodoc ../{README.txt,credits.txt,changelog.txt}
}
