# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="python-textile"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python port of Textile, A humane web text generator"
HOMEPAGE="https://github.com/textile/python-textile"
SRC_URI="https://github.com/textile/python-textile/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	# remove useless --cov arg injection
	rm pytest.ini || die
	# remove useless pytest-runner dep
	sed -e "s/pytest-runner//g" -i setup.py || die

	# remove tests that need network access
	local my_drop_tests=(
		test_getimagesize.py
		test_imagesize.py
		test_textile.py
	)
	for test in ${my_drop_tests[@]};
		do rm "tests/$test" || die
	done
}

python_test() {
	pytest || die "Testsuite failed under ${EPYTHON}"
}
