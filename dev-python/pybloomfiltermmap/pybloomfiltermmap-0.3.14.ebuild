# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pybloomfiltermmap/pybloomfiltermmap-0.3.14.ebuild,v 1.2 2014/07/01 04:27:42 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A Bloom filter (bloomfilter) for Python built on mmap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="http://pypi.python.org/pypi/pybloomfiltermmap"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	# Failures X 2 by pypy are harmless; written for py2, reflect only how pypy handles exceptions
	"${PYTHON}" -m unittest tests.test_all || die "Tests failed"
}
