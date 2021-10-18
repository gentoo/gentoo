# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Vietnamese UniKey engine for IBus"
HOMEPAGE="https://github.com/vn-input/ibus-unikey"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~dlan/distfiles/${P}-gcc6.patch"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="app-i18n/ibus
	x11-libs/libX11
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	dev-util/intltool
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-slibtool.patch
	"${DISTDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk-version=3
}
