# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1 bash-completion-r1 vcs-snapshot

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python"
HOMEPAGE="http://pygments.org/ http://pypi.python.org/pypi/Pygments"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/ttf-fonts )"
#		dev-texlive/texlive-latexrecommended
# Removing / commenting out this dep. I can find no mention of it in tests other than
# importing pygment's own tex module.  If it's there and I missed it just uncomment and re-add
# Tests pass without it

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	cp -r -l tests "${BUILD_DIR}"/ || die
	# With pypy3 there is 1 error out of 1556 tests when run as is and
	# (SKIP=8, errors=1, failures=1) when run with 2to3; meh
	nosetests -w "${BUILD_DIR}"/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
	newbashcomp external/pygments.bashcomp pygmentize
}
