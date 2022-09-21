# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Micro subset of unicode data files for linkify-it-py projects"
HOMEPAGE="
	https://github.com/tsutsu3/uc.micro-py/
	https://pypi.org/project/uc-micro-py/
"
SRC_URI="
	https://github.com/tsutsu3/uc.micro-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc"

distutils_enable_tests pytest
