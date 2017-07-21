# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Tracks your time from the command line, and generates reports"
HOMEPAGE="https://taskwarrior.org/news/news.20160821.html"
SRC_URI="https://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DTIMEW_DOCDIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}
