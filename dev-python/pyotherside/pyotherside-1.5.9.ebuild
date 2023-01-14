# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit qmake-utils python-single-r1

DESCRIPTION="Asynchronous Python 3 Bindings for Qt 5"
HOMEPAGE="https://github.com/thp/pyotherside https://thp.io/2011/pyotherside/"
SRC_URI="https://github.com/thp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s/qtquicktests//" pyotherside.pro || die
}

src_configure() {
	eqmake5
}

src_test() {
	QT_QPA_PLATFORM="offscreen" tests/tests || die
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
