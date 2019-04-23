# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{5,6} )

inherit qmake-utils python-single-r1

DESCRIPTION="Asynchronous Python 3 Bindings for Qt 5"
HOMEPAGE="https://github.com/thp/pyotherside https://thp.io/2011/pyotherside/"
SRC_URI="https://github.com/thp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	sed -i -e "s/qtquicktests//" pyotherside.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
