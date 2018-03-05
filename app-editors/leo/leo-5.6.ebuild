# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}-editor-${PV}"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQUIRED_USE="tk"
inherit distutils-r1

DESCRIPTION="Leo: Literate Editor with Outlines"
HOMEPAGE="https://github.com/leo-editor/leo-editor/"
SRC_URI="https://github.com/leo-editor/leo-editor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	app-text/silvercity[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	cp leo/dist/setup.py leo/dist/leo-install.py . || die
}

python_install_all() {
	use doc && local HTML_DOCS=( leo/doc/html/. )
	distutils-r1_python_install_all
}
