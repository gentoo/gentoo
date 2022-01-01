# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_COMMIT="5f665f60083a9796ec33861240ce31d6d2b844b6"

MY_PN="Js2Py"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="JavaScript to Python Translator & JavaScript interpreter in Python"
HOMEPAGE="
	http://piter.io/projects/js2py/
	https://github.com/PiotrDabkowski/Js2Py/
	https://pypi.org/project/Js2Py/
"
SRC_URI="https://github.com/PiotrDabkowski/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	>=dev-python/pyjsparser-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

python_test() {
	pushd ./tests >/dev/null || die

	# Tests require "node_failed.txt" file where the logs are kept
	if [[ -f ./node_failed.txt ]]; then
		rm ./node_failed.txt || die
	fi

	touch ./node_failed.txt || die
	"${EPYTHON}" ./run.py || die "tests failed with ${EPYTHON}"

	popd >/dev/null || die
}
