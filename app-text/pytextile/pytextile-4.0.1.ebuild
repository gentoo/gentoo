# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P="python-textile-${PV}"

DESCRIPTION="A Python port of Textile, A humane web text generator"
HOMEPAGE="https://github.com/textile/python-textile"
SRC_URI="https://github.com/textile/python-textile/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

src_prepare() {
	default
	# remove useless --cov arg injection
	rm pytest.ini || die
	# remove useless pytest-runner dep
	sed -e "s/pytest-runner//g" -i setup.py || die
}

python_test() {
	local deselect=(
		# tests that need network access
		tests/test_getimagesize.py
		tests/test_imagesize.py
		tests/test_textile.py
	)
	epytest ${deselect[@]/#/--deselect }
}
