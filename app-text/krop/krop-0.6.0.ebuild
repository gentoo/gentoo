# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit desktop distutils-r1 xdg-utils

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arminstraub/krop.git"
else
	SRC_URI="https://github.com/arminstraub/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="A tool to crop PDF files"
HOMEPAGE="http://arminstraub.com/software/krop"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="dev-python/python-poppler-qt5[${PYTHON_USEDEP}]
	dev-python/PyPDF2[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets]"

src_install() {
	distutils-r1_src_install
	domenu "${WORKDIR}/${P}/${PN}.desktop"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
