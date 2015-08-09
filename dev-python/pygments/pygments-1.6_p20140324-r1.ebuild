# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 bash-completion-r1 vcs-snapshot

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python"
HOMEPAGE="http://pygments.org/ http://pypi.python.org/pypi/Pygments"
#SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
SRC_URI="https://bitbucket.org/birkenfeld/pygments-main/get/b839f47dbb3a10830db7dc3114f0ad4f470bcfa5.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/ttf-fonts
		dev-texlive/texlive-latexrecommended
	)"

#S="${WORKDIR}/${MY_P}"

python_compile() {
	distutils-r1_python_compile
	if [[ ${EPYTHON} == python3.2 ]]; then
		# python3.2 does not like u"" literals
		2to3 --no-diffs -n -w -f unicode "${BUILD_DIR}/lib" || die
	fi
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	cp -r -l tests "${BUILD_DIR}"/ || die

	if python_is_python3; then
		# Notes:
		#   -W is not supported by python3.1
		#   -n causes Python to write into hardlinked files
		2to3 --no-diffs -w "${BUILD_DIR}"/tests/*.py || die
	fi

	nosetests -w "${BUILD_DIR}"/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
	newbashcomp external/pygments.bashcomp pygmentize
}
