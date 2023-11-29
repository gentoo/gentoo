# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1

MY_COMMIT="877acddfd5ac5ae8b4a4592d045e74e108477643"

DESCRIPTION="A PEG-based parser interpreter with memoization"
HOMEPAGE="https://github.com/avakar/speg/"
SRC_URI="https://github.com/avakar/speg/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${PN}-${MY_COMMIT}

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"

distutils_enable_tests pytest

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
