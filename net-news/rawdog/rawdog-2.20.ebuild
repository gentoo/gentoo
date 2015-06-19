# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/rawdog/rawdog-2.20.ebuild,v 1.1 2014/10/11 08:47:01 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Rawdog - RSS Aggregator Without Delusions Of Grandeur"
HOMEPAGE="http://offog.org/code/rawdog.html http://pypi.python.org/pypi/rawdog"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

DEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"
RDEPEND=""
# Test run fails under multi threading
DISTUTILS_NO_PARALLEL_BUILD=1

python_test() {
	# pypy fails half way through; meh
	./test-rawdog || die "Test run aborted"
}
