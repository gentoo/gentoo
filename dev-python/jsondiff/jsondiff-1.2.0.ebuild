# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Diff JSON and JSON-like structures in Python"
HOMEPAGE="https://github.com/xlwings/jsondiff https://pypi.org/project/jsondiff/"
SRC_URI="https://github.com/fzumstein/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

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
