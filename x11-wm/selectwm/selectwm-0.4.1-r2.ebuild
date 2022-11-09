# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="window manager selector tool"
HOMEPAGE="https://ordiluc.net/selectwm"
SRC_URI="https://ordiluc.net/selectwm/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-enable-deprecated-gtk.patch
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--program-suffix=2 \
		$(use_enable nls)
}

src_install() {
	default
	dodoc sample.xinitrc
}
