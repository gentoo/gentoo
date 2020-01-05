# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Rawdog, RSS Aggregator Without Delusions Of Grandeur"
HOMEPAGE="http://offog.org/code/rawdog.html https://pypi.org/project/rawdog/"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~s390 sparc x86"

DEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	# pypy fails half way through; meh
	./test-rawdog || die "Test run aborted"
}
