# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nose/nose-1.3.7.ebuild,v 1.1 2015/06/03 08:42:19 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A unittest extension offering automatic test suite discovery and easy test authoring"
HOMEPAGE="
	http://pypi.python.org/pypi/nose
	http://readthedocs.org/docs/nose/
	https://bitbucket.org/jpellerin/nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples test"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6[${PYTHON_USEDEP}] )
	test? ( $(python_gen_cond_dep 'dev-python/twisted-core[${PYTHON_USEDEP}]' python2_7) )"

python_prepare_all() {
	# Tests need to be converted, and they don't respect BUILD_DIR.
	use test && DISTUTILS_IN_SOURCE_BUILD=1

	# Disable tests requiring network connection.
	sed \
		-e "s/test_resolve/_&/g" \
		-e "s/test_raises_bad_return/_&/g" \
		-e "s/test_raises_twisted_error/_&/g" \
		-i unit_tests/test_twisted.py || die "sed failed"
	# Disable versioning of nosetests script to avoid collision with
	# versioning performed by the eclass.
	sed -e "/'nosetests%s = nose:run_exit' % py_vers_tag,/d" \
		-i setup.py || die "sed2 failed"

	# Prevent un-needed d'loading during doc build
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i doc/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local add_targets=()

	if use test; then
		add_targets+=( egg_info )
		python_is_python3 && add_targets+=( build_tests )
	fi

	distutils-r1_python_compile ${add_targets[@]}
}

python_compile_all() {
	use doc && emake -C doc html
}

src_test() {
	# nosetests use heavy multiprocessing during the tests.
	# this shall make them less likely to kill your system or timeout.
	local DISTUTILS_NO_PARALLEL_BUILD=1

	distutils-r1_src_test
}

python_test() {
	"${PYTHON}" selftest.py -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install --install-data "${EPREFIX}/usr/share"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all

	if use doc; then
		dohtml -r -A txt doc/.build/html/.
	fi
}
