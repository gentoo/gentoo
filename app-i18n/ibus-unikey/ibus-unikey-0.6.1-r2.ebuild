# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Vietnamese UniKey engine for IBus"
HOMEPAGE="https://github.com/mrlequoctuan/ibus-unikey"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~dlan/distfiles/${P}-gcc6.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3 nls"

RDEPEND="app-i18n/ibus
	x11-libs/libX11
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	nls? ( sys-devel/gettext )"

PATCHES=( "${DISTDIR}"/${P}-gcc6.patch )

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk-version=$(usex gtk3 3 2)
}
