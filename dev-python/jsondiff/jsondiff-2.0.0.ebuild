# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Diff JSON and JSON-like structures in Python"
HOMEPAGE="
	https://github.com/xlwings/jsondiff/
	https://pypi.org/project/jsondiff/
"
SRC_URI="
	https://github.com/xlwings/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/nose-random[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

python_prepare_all() {
	# Avoid file collision with jsonpatch's jsondiff cli.
	sed -e "/'jsondiff=jsondiff.cli/ d" -i setup.py || die
	distutils-r1_python_prepare_all
}
