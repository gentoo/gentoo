# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=python-cstruct-${PV}
DESCRIPTION="C-style structs for Python"
HOMEPAGE="
	https://github.com/andreax79/python-cstruct/
	https://pypi.org/project/cstruct/
"
SRC_URI="
	https://github.com/andreax79/python-cstruct/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )

distutils_enable_tests pytest
