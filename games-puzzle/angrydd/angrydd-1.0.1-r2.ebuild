# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop python-single-r1

DESCRIPTION="Angry, Drunken Dwarves, a falling blocks game similar to Puzzle Fighter"
HOMEPAGE="https://www.sacredchao.net/~piman/angrydd/"
SRC_URI="https://www.sacredchao.net/~piman/angrydd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	python_fix_shebang .
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr/share/" \
		TO="${PN}" \
		install
	rm -rf "${ED}/usr/share/games" "${ED}/usr/share/share" || die

	python_optimize "${ED}/usr/share/${PN}"

	dodir /usr/bin
	dosym "${ED}/usr/share/${PN}/angrydd.py" "/usr/bin/${PN}"
	doman angrydd.6
	dodoc README TODO HACKING

	doicon angrydd.png
	make_desktop_entry angrydd "Angry, Drunken Dwarves"
}
