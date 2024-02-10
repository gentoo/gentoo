# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=pdm-backend

inherit distutils-r1

DESCRIPTION="Python handler for dev-python/mkdocstrings"
HOMEPAGE="
	https://mkdocstrings.github.io/python/
	https://github.com/mkdocstrings/python/
	https://pypi.org/project/mkdocstrings-python/
"
# Tests need files absent from the PyPI tarballs
SRC_URI="
	https://github.com/mkdocstrings/python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/griffe-0.37[${PYTHON_USEDEP}]
	dev-python/mkdocstrings[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}
