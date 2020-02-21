# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Color Bandwidth Meter"
HOMEPAGE="
	http://www.isotton.com/software/unix/cbm/
	https://github.com/resurrecting-open-source-projects/cbm
"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	app-text/docbook-xml-dtd:4.4
	app-text/xmlto
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.2-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}
