# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="Python bindings for the CUPS API"
HOMEPAGE="http://cyberelk.net/tim/data/pycups/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86"
SLOT="0"
IUSE="doc examples"

RDEPEND="
	net-print/cups
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}
"

# epydoc kinda sucks and supports python2 only (it's dead too),
# and since we're dealing with a binary module we need exact version
# match. therefore, docbuilding *requires* any python2 being enabled.

DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )
"

REQUIRED_USE="doc? ( || ( $(python_gen_useflags 'python2*') ) )"

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( python2.7 )
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		# we can't use Makefile since it relies on hardcoded paths
		epydoc -o html --html cups || die "doc build failed"
		HTML_DOCS=( html/. )
	fi
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
