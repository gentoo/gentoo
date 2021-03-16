# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="tool that allows you to tune SiS drivers from X"
HOMEPAGE="http://www.winischhofer.net/linuxsispart1.shtml#sisctrl"
SRC_URI="http://www.winischhofer.net/sis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libXrender
	x11-libs/libXv
	x11-libs/libXxf86vm
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-no-xv.patch
)

src_configure() {
	append-libs -lm
	econf \
		--with-xv-path="${EPREFIX}/usr/$(get_libdir)"
}
