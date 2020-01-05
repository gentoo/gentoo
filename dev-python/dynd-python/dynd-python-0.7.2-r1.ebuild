# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

# change each new dynd version, to avoid git in tree dependency
DYND_PYTHON_GIT_SHA1=8cdef57e71c784d7fe1f3f97a2ce2ce5727a89f1

DESCRIPTION="Python exposure of multidimensionnal array library libdynd"
HOMEPAGE="http://libdynd.org/"
SRC_URI="https://github.com/libdynd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	~dev-libs/libdynd-${PV}
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# remove the version mangling from git stuff it requires a git clone
	# rather force set it a configure time
	sed -e "/--dirty/s/ver =.*/ver = 'v${PV}'/" \
		-e '/--always/d' \
		-i setup.py || die
	sed -e "s/get_git.*/set(DYND_PYTHON_GIT_SHA1 ${DYND_PYTHON_GIT_SHA1})/" \
		-e "s/git_describe.*/set(DYND_PYTHON_VERSION_STRING v${PV})/" \
		-e 's|-g -fomit-frame-pointer||' \
		-e 's|-Werror||g' \
		-i CMakeLists.txt || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	cd "${BUILD_DIR}/lib" || die
	PYTHONPATH=${BUILD_DIR}/lib nosetests -v || die
}
