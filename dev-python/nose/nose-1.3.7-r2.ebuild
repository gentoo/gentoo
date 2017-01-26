# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Unittest extension with automatic test suite discovery and easy test authoring"
HOMEPAGE="
	https://pypi.python.org/pypi/nose
	http://readthedocs.org/docs/nose/
	https://bitbucket.org/jpellerin/nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"

REQUIRED_USE="
	doc? ( || ( $(python_gen_useflags 'python2*') ) )"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6[${PYTHON_USEDEP}] )
	test? ( $(python_gen_cond_dep 'dev-python/twisted-core[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=(
	"${FILESDIR}"/${P}-python-3.5-backport.patch

	# Patch against master found in an upstream PR, backported:
	# https://github.com/nose-devs/nose/pull/1004
	"${FILESDIR}"/${P}-coverage-4.1-support.patch
)

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( 'python2*' )
}

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

python_test() {
	"${PYTHON}" selftest.py -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install --install-data "${EPREFIX}/usr/share"
}

python_install_all() {
	use examples && dodoc -r examples
	use doc && HTML_DOCS=( doc/.build/html/. )
	distutils-r1_python_install_all
}
