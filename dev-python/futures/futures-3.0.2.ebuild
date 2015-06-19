# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/futures/futures-3.0.2.ebuild,v 1.1 2015/06/16 08:51:54 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )
inherit distutils-r1

DESCRIPTION="Backport of the concurrent.futures package from Python 3.2"
HOMEPAGE="http://code.google.com/p/pythonfutures  http://pypi.python.org/pypi/futures"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# tests that fail under pypy
	# http://code.google.com/p/pythonfutures/issues/detail?id=27
	if [[ "${EPYTHON}" == pypy ]]; then
		sed -e 's:test_del_shutdown:_&:g' \
			-e 's:test_repr:_&:' -i test_futures.py || die
	fi
	"${PYTHON}" test_futures.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
