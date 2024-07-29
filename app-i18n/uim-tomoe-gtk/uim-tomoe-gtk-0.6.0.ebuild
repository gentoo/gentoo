# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Japanese input method Tomoe IMEngine for uim"
HOMEPAGE="http://tomoe.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-i18n/uim
	~app-i18n/tomoe-gtk-0.6.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
