# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/promise/promise-0.2.2-r1.ebuild,v 1.1 2015/02/16 15:20:36 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Bytecode optimisation using staticness assertions"
HOMEPAGE="https://github.com/rfk/promise/ http://pypi.python.org/pypi/promise"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_test() {
	# Timing tests fail.
	PROMISE_SKIP_TIMING_TESTS="1" nosetests || die "tests failed"
}
