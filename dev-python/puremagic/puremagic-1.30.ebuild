# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Pure python implementation of magic file detection"
HOMEPAGE="
	https://github.com/cdgriffith/puremagic/
	https://pypi.org/project/puremagic/
"
SRC_URI="
	https://github.com/cdgriffith/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

DOCS=( CHANGELOG.md README.rst )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
