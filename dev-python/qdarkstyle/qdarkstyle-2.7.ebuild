# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit eutils distutils-r1

MY_PN="QDarkStyleSheet"

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"
SRC_URI="https://github.com/ColinDuquesnoy/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples test doc"

RDEPEND=">=dev-python/helpdev-0.6.2[${PYTHON_USEDEP}]
	doc? ( dev-python/m2r[${PYTHON_USEDEP}] )
	examples? ( >=dev-python/QtPy-1.7[${PYTHON_USEDEP}] )"

DEPEND="test? ( dev-python/QtPy[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme

S="${WORKDIR}/${MY_PN}-${PV}"

python_install_all() {
	if use examples; then
		insinto /usr/share/${PN}
		doins -r example
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
		optfeature "To use qdarkstyle.utils please install" dev-python/qtsass
}
