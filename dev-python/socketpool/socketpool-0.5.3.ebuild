# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="A simple Python socket pool"
HOMEPAGE="https://github.com/benoitc/socketpool/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 arm ~arm64 ppc ppc64 s390 ~sh ~sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"
LICENSE="|| ( MIT public-domain )"
SLOT="0"

RDEPEND="$(python_gen_cond_dep 'dev-python/gevent[${PYTHON_USEDEP}]' 'python2*')"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-locale.patch )

python_test() {
	py.test tests || die
}

python_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	distutils-r1_python_install_all

	# package installs unneeded LICENSE files here
	rm -rf "${ED}"/usr/socketpool || die
}
