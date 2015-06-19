# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/quixote/quixote-2.8.ebuild,v 1.4 2015/01/28 10:33:20 ago Exp $

EAPI=5
# Appears to be written only for py2
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_P="${P/q/Q}"

DESCRIPTION="Python HTML templating framework for developing web applications"
HOMEPAGE="http://quixote.ca"
SRC_URI="http://quixote.ca/releases/${MY_P}.tar.gz"

LICENSE="CNRI-QUIXOTE-2.4"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc test"

DEPEND="doc? ( dev-python/docutils[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}
# tests require a running quixote server, prob. apt. post install. Tried the demo one but no
RESTRICT="test"

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C doc
}

python_test() {
	nosetests tests || die "tests failed"
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
