# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit python-single-r1

DESCRIPTION="Educational tool for relational algebra"
HOMEPAGE="https://ltworf.github.io/relational/"
SRC_URI="https://github.com/ltworf/${PN}/releases/download/${PV}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	dev-python/PyQt5[gui,webkit,widgets,${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	sed -i -e '/^Terminal=/ s/0/false/' \
		-e '/^Keywords=/ s/$/;/' \
		relational.desktop || die
}

src_install() {
	emake -j1 DESTDIR="${ED}" install-{relational-cli,python3-relational,relational}
	python_optimize

	dodoc CHANGELOG complexity CREDITS README.md
}
