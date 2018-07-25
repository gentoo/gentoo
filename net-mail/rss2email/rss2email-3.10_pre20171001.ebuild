# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DEBIAN_PV=${PV/_*/}-4

MY_COMMIT=e21e803a158a90ed784ee61ce7226e5c3a593a28
DESCRIPTION="A python script that converts RSS/Atom newsfeeds to email"
HOMEPAGE="https://github.com/rss2email/rss2email"
SRC_URI="https://github.com/rss2email/rss2email/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-util/patchutils"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/feedparser-5.0.1
	>=dev-python/html2text-3.01"

S="${WORKDIR}"/${PN}-${MY_COMMIT}

src_install() {
	distutils-r1_src_install
	doman r2e.1
}
