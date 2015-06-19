# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/beautifulsoup/beautifulsoup-3.2.1-r1.ebuild,v 1.18 2015/03/03 07:00:13 dlan Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PN="BeautifulSoup"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HTML/XML parser for quick-turnaround applications like screen-scraping"
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/ http://pypi.python.org/pypi/BeautifulSoup"
SRC_URI="http://www.crummy.com/software/${MY_PN}/download/3.x/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="python-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="!dev-python/beautifulsoup:0"

S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" BeautifulSoupTests.py || die "Testing failed with ${EPYTHON}"
}
