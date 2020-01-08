# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Support for 3.4 and 3.5 is broken upstream, see https://github.com/rss2email/rss2email/issues/80
# Support for 3.7 needs support from dependencies, first
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A python script that converts RSS/Atom newsfeeds to email"
HOMEPAGE="https://github.com/rss2email/rss2email"
SRC_URI="https://github.com/rss2email/rss2email/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=dev-python/feedparser-5.0.1[${PYTHON_USEDEP}]
	>=dev-python/html2text-3.01[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install
	doman r2e.1
}
