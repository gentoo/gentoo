# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-single-r1

DESCRIPTION="Educational tool for relational algebra"
HOMEPAGE="https://ltworf.github.io/relational/"
SRC_URI="https://github.com/ltworf/${PN}/releases/download/${PV}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/PyQt5[gui,widgets,${PYTHON_MULTI_USEDEP}]
	')
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${P}-no-qtwebkit.patch" )

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
