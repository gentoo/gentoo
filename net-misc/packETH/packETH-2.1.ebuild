# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Packet generator tool for ethernet"
HOMEPAGE="http://packeth.sourceforge.net/"
SRC_URI="https://github.com/jemcek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.8.1-libs-and-flags.patch
	"${FILESDIR}"/${PN}-2.1-fno-common.patch
)
DOCS=( AUTHORS CHANGELOG README )

src_prepare() {
	default
	eautoreconf
}
