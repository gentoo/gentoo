# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple Python socket pool"
HOMEPAGE="https://github.com/benoitc/socketpool/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 s390 ~sh ~sparc ~x86"
IUSE="examples test"
LICENSE="|| ( MIT public-domain )"
SLOT="0"

RDEPEND="$(python_gen_cond_dep 'dev-python/gevent[${PYTHON_USEDEP}]' 'python2*')"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-locale.patch )

distutils_enable_tests pytest

python_test() {
	cp -r examples tests "${BUILD_DIR}" || die

	pushd "${BUILD_DIR}" >/dev/null || die
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
	popd >/dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples

	# package installs unneeded LICENSE files here
	rm -r "${ED}"/usr/socketpool || die
}
