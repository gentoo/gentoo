# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit desktop distutils-r1 xdg

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arminstraub/krop.git"
else
	MY_COMMIT="e96d42b2f1ab4317efe37cab498b708663bc104c"
	SRC_URI="https://github.com/arminstraub/krop/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool to crop PDF files"
HOMEPAGE="http://arminstraub.com/software/krop"
LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/python-poppler-qt5[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets]
	|| (
	   dev-python/pypdf[${PYTHON_USEDEP}]
	   dev-python/pikepdf[${PYTHON_USEDEP}]
	)
"

src_install() {
	distutils-r1_src_install
	domenu "${WORKDIR}/${PN}-${MY_COMMIT}/${PN}.desktop"
}
