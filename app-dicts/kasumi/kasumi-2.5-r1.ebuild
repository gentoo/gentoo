# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Anthy dictionary maintenance tool"
HOMEPAGE="http://kasumi.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/41436/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="nls"

RDEPEND="app-i18n/anthy
	virtual/libiconv
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-desktop.patch )

src_configure() {
	econf $(use_enable nls)
}
