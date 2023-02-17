# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Constraint Solving Problem resolver for Python"
HOMEPAGE="https://github.com/python-constraint/python-constraint"
SRC_URI="https://github.com/python-constraint/python-constraint/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/python-constraint-1.4.0-exclude-examples.patch"
)

distutils_enable_tests pytest
