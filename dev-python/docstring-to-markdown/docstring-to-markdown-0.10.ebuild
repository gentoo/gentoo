# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="On the fly conversion of Python docstrings to markdown"
HOMEPAGE="https://github.com/python-lsp/docstring-to-markdown"
SRC_URI="https://github.com/python-lsp/docstring-to-markdown/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests pytest

python_prepare_all() {
	# Do not depend on pytest-cov/pytest-flake8
	sed -e '/--cov/d' -e '/--flake8/d' -i setup.cfg || die

	distutils-r1_python_prepare_all
}
