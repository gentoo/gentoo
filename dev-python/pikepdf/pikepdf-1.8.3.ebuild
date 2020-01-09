# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python library to work with pdf files based on qpdf"
HOMEPAGE="https://pypi.org/project/pikepdf/ https://github.com/pikepdf/pikepdf"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="app-text/qpdf
	dev-python/pybind11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]"
