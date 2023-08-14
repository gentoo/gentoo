# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=pyjson5-${PV}
DESCRIPTION="A Python implementation of the JSON5 data format"
HOMEPAGE="
	https://github.com/dpranke/pyjson5/
	https://pypi.org/project/json5/
"
SRC_URI="
	https://github.com/dpranke/pyjson5/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest
