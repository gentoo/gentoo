# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyquery/pyquery-1.2.4.ebuild,v 1.16 2014/12/20 07:53:50 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="http://pypi.python.org/pypi/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="beautifulsoup3 test"

RDEPEND=">=dev-python/lxml-2.1[beautifulsoup3?,${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2_rc1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
REQUIRED_USE="test? ( beautifulsoup3 )"

DOCS=( CHANGES.rst README.rst )

python_prepare_all() {
	# Disable tests that access the net
	for file in docs/{ajax.txt,manipulating.txt,scrap.txt,tips.txt}
	do
		mv ${file} ${file/.txt/}  || die
	done
	sed -e 's:>>> d = pq(url:>>> # d = pq(url:' -i README.rst || die
	sed -e 's:class TestWebScrapping:class _TestWebScrapping:' -i ${PN}/test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
