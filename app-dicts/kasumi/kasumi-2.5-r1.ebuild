# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Anthy dictionary maintenance tool"
HOMEPAGE="http://kasumi.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/41436/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-fbsd"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.6:2
	nls? ( virtual/libintl )
	virtual/libiconv
	>=app-i18n/anthy-6131"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-r1-fix-desktop-QA.patch
}

src_configure() {
	econf $(use_enable nls)
}
