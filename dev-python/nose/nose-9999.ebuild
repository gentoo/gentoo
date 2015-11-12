# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
EGIT_REPO_URI="git://github.com/nose-devs/${PN}.git
	https://github.com/nose-devs/${PN}.git"
inherit git-2
#endif

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1 eutils

DESCRIPTION="A unittest extension offering automatic test suite discovery and easy test authoring"
HOMEPAGE="https://pypi.python.org/pypi/nose http://readthedocs.org/docs/nose/ https://github.com/nose-devs/nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

RDEPEND="dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6 )
	test? ( dev-python/twisted-core )"

#if LIVE
SRC_URI=
KEYWORDS=
#endif

DOCS=( AUTHORS )

python_prepare_all() {
	# Tests need to be converted, and they don't respect BUILD_DIR.
	use test && DISTUTILS_IN_SOURCE_BUILD=1

	# Disable sphinx.ext.intersphinx, requires network
	epatch "${FILESDIR}/${PN}-0.11.0-disable_intersphinx.patch"
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

	distutils-r1_python_prepare_all
}

python_compile() {
	local add_targets=()

	if use test; then
		add_targets+=( egg_info )
		[[ ${EPYTHON} == python3* ]] && add_targets+=( build_tests )
	fi

	distutils-r1_python_compile ${add_targets[@]}
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	"${PYTHON}" selftest.py || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install --install-data "${EPREFIX}/usr/share"
}

python_install_all() {
	local EXAMPLES=( examples/. )
	distutils-r1_python_install_all

	if use doc; then
		dohtml -r -A txt doc/.build/html/.
	fi
}
