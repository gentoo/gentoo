# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# py3.13: https://github.com/CheetahTemplate3/cheetah3/issues/60
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="
	https://cheetahtemplate.org/
	https://github.com/CheetahTemplate3/Cheetah3/
	https://pypi.org/project/Cheetah3/
"
SRC_URI="
	https://github.com/CheetahTemplate3/Cheetah3/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

DOCS=( ANNOUNCE.rst README.rst TODO )

python_test() {
	# the package can't handle TMPDIR with hyphens
	# https://github.com/CheetahTemplate3/cheetah3/issues/53
	local -x TMPDIR=/tmp

	"${EPYTHON}" Cheetah/Tests/Test.py || die "Tests fail with ${EPYTHON}"
}
