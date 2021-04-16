# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JPEG image to ASCII art converter"
HOMEPAGE="https://github.com/Talinx/jp2a"
SRC_URI="https://github.com/Talinx/jp2a/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="curl"

RDEPEND="
	curl? ( net-misc/curl )
	sys-libs/ncurses
	virtual/jpeg
"
DEPEND="${RDEPEND}"

HTML_DOCS=( man/jp2a.1 )

src_configure() {
	econf \
		$(use_enable curl)
}
