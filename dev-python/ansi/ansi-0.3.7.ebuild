# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${PN}-${P}
DESCRIPTION="ANSI cursor movement and graphics in Python"
HOMEPAGE="
	https://github.com/tehmaze/ansi/
	https://pypi.org/project/ansi/
"
SRC_URI="
	https://github.com/tehmaze/ansi/archive/${P}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

distutils_enable_tests pytest
