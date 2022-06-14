# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=b16d7ce90ac9c03358010c1599c3e87698c9993f
MY_PN=Js2Py
MY_P=${MY_PN}-${PV}

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="JavaScript to Python Translator & JavaScript interpreter in Python"
HOMEPAGE=" http://piter.io/projects/js2py/
	https://github.com/PiotrDabkowski/Js2Py/
	https://pypi.org/project/Js2Py/"
SRC_URI="https://github.com/PiotrDabkowski/${MY_PN}/archive/${H}.tar.gz
			-> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${H}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pyjsparser-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"

python_test() {
	pushd ./tests >/dev/null || die

	# Tests require "node_failed.txt" file where the logs are kept
	if [[ -f ./node_failed.txt ]] ; then
		rm ./node_failed.txt || die
	fi

	touch ./node_failed.txt || die
	"${EPYTHON}" ./run.py || die "tests failed with ${EPYTHON}"

	popd >/dev/null || die
}
