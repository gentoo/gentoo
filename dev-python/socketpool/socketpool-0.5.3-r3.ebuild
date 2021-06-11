# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple Python socket pool"
HOMEPAGE="https://github.com/benoitc/socketpool/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 ~sparc x86 ~x64-macos"
IUSE="eventlet examples gevent"
LICENSE="|| ( MIT public-domain )"
SLOT="0"

RDEPEND="
	eventlet? (
		$(python_gen_cond_dep '
			dev-python/eventlet[${PYTHON_USEDEP}]
		' python3_{7..9})
	)
	gevent? (
		$(python_gen_cond_dep '
			dev-python/gevent[${PYTHON_USEDEP}]
		' python3_{7..9})
	)"

BDEPEND="
	test? (
		!alpha? ( !hppa? ( !ia64? (
			$(python_gen_cond_dep '
				dev-python/eventlet[${PYTHON_USEDEP}]
			' python3_{7..9})
			$(python_gen_cond_dep '
				dev-python/gevent[${PYTHON_USEDEP}]
			' python3_{7..9})
		) ) )
	)"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-locale.patch )

distutils_enable_tests pytest

src_prepare() {
	# py3.9
	sed -i -e 's:isAlive:is_alive:' socketpool/backend_thread.py || die

	distutils-r1_src_prepare
}

python_test() {
	cp -r examples tests "${BUILD_DIR}" || die

	pushd "${BUILD_DIR}" >/dev/null || die
	epytest tests
	popd >/dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples

	# package installs unneeded LICENSE files here
	rm -r "${ED}"/usr/socketpool || die
}
