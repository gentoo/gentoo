# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit qmake-utils python-single-r1

DESCRIPTION="Asynchronous Python 3 Bindings for Qt"
HOMEPAGE="
	https://github.com/thp/pyotherside/
	https://thp.io/2011/pyotherside/
"
SRC_URI="https://github.com/thp/pyotherside/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	dev-qt/qtbase:6[opengl]
	dev-qt/qtdeclarative:6[opengl]
	dev-qt/qtquick3d:6[opengl]
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	sed -i -e "s/qtquicktests//" pyotherside.pro || die
}

src_configure() {
	eqmake6
}

src_test() {
	QT_QPA_PLATFORM="offscreen" tests/tests || die
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
