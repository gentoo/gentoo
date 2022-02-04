# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="JPEG image to ASCII art converter"
HOMEPAGE="http://csl.sublevel3.org/jp2a/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="curl"

RDEPEND="sys-libs/ncurses
	virtual/jpeg
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}"

HTML_DOCS=( man/jp2a.html )

src_configure() {
	econf \
		$(use_enable curl)
}
