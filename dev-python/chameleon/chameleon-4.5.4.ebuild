# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Fast HTML/XML template compiler for Python"
HOMEPAGE="
	https://github.com/malthe/chameleon/
	https://pypi.org/project/Chameleon/
"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest
