# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Support for Python >=3.9 currently broken by feedparser <6
# (see bug https://bugs.gentoo.org/768120)
PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="A python script that converts RSS/Atom newsfeeds to email"
HOMEPAGE="https://github.com/rss2email/rss2email"
SRC_URI="https://github.com/rss2email/rss2email/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="<dev-python/feedparser-6[${PYTHON_USEDEP}]
	>=dev-python/html2text-3.01[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install
	doman r2e.1
}
