# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycups/pycups-1.9.72.ebuild,v 1.1 2015/05/27 20:43:32 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Python bindings for the CUPS API"
HOMEPAGE="http://cyberelk.net/tim/data/pycups/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
SLOT="0"
IUSE="doc examples"

RDEPEND="
	net-print/cups
"
DEPEND="${RDEPEND}"

# epydoc kinda sucks and supports python2 only (it's dead too),
# and since we're dealing with a binary module we need exact version
# match. therefore, docbuilding *requires* any python2 being enabled.

DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )
"

REQUIRED_USE="doc? ( || ( $(python_gen_useflags 'python2*') ) )"

python_compile_all() {
	if use doc; then
		# we can't use Makefile since it relies on hardcoded paths
		epydoc -o html --html cups || die "doc build failed"
	fi
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_install_all() {
	use doc && local HTML_DOCS=( html/ )
	use examples && local EXAMPLES=( examples/ )

	distutils-r1_python_install_all
}
