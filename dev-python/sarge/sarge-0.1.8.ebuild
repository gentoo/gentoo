# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Wrapper for subprocess which provides command pipeline functionality"
HOMEPAGE="
	https://docs.red-dove.com/sarge/
	https://pypi.org/project/sarge/
	https://github.com/vsajip/sarge/
"
SRC_URI="
	https://github.com/vsajip/sarge/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

python_test() {
	"${EPYTHON}" test_sarge.py -v || die "Tests failed with ${EPYTHON}"
}
