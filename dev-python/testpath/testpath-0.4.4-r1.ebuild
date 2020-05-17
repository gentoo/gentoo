# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Test utilities for code working with files and commands"
HOMEPAGE="https://github.com/jupyter/testpath https://testpath.readthedocs.io/en/latest/"
SRC_URI="https://github.com/jupyter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	test? (
		dev-python/pathlib2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc
