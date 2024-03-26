# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="A python script that converts RSS/Atom newsfeeds to email"
HOMEPAGE="https://github.com/rss2email/rss2email"
SRC_URI="https://github.com/rss2email/rss2email/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND=">=dev-python/feedparser-6.0.5[${PYTHON_USEDEP}]
	>=dev-python/html2text-2020.1.16[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tests.patch
)

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	doman r2e.1
}

python_test() {
	cd test/ || die  # or the tests won't find their data
	distutils-r1_python_test
}
