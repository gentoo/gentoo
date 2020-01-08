# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-single-r1

DESCRIPTION="Angry, Drunken Dwarves, a falling blocks game similar to Puzzle Fighter"
HOMEPAGE="https://www.sacredchao.net/~piman/angrydd/"
SRC_URI="
	https://www.sacredchao.net/~piman/angrydd/${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${P/_p*}"

src_prepare() {
	default
	eapply -p1 "${WORKDIR}"/debian/patches/*.patch
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
	dosym "../share/${PN}/angrydd.py" "/usr/bin/${PN}"
	doman angrydd.6
	dodoc README TODO HACKING

	doicon angrydd.png
	make_desktop_entry angrydd "Angry, Drunken Dwarves"
}
