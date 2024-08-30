# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python module/script that generates Sphinx markup to describe a C API"
HOMEPAGE="
	https://gitlab.com/drobilla/sphinxygen/
	https://pypi.org/project/sphinxygen/
"
SRC_URI="
	https://gitlab.com/drobilla/sphinxygen/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	app-text/doxygen
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/html5lib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
