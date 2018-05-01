# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop python-single-r1

DESCRIPTION="Hexagonal Minesweeper"
HOMEPAGE="https://sourceforge.net/projects/hexamine"
SRC_URI="mirror://sourceforge/hexamine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame
"
DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	# Modify game data directory
	sed -i \
		-e "s:\`dirname \$0\`:/usr/share/${PN}:" \
		-e "s:\./hexamine:exec ${EPYTHON} &:" \
		hexamine || die
}

src_install() {
	dobin hexamine
	insinto "/usr/share/${PN}"
	doins -r hexamine.* skins
	einstalldocs
	make_desktop_entry ${PN} "Hexamine"
}
