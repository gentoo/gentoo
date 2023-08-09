# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

MY_P=hiredis-py-${PV}
DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="
	https://github.com/redis/hiredis-py/
	https://pypi.org/project/hiredis/
"
SRC_URI="
	https://github.com/redis/hiredis-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	>=dev-libs/hiredis-1.0.0:=
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/hiredis-2.2.2-system-libs.patch
)

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf hiredis || die
	epytest
}
