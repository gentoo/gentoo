# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=(python3_{7..9})

inherit distutils-r1

DESCRIPTION="manages your Python library's sample data files"
HOMEPAGE="https://github.com/fatiando/pooch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

BDEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pytest-localftpserver[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc dev-python/sphinx_rtd_theme

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
