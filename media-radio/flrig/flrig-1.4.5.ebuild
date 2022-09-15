# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Transceiver control program for Amateur Radio use"
HOMEPAGE="http://www.w1hkj.com/flrig-help/index.html"
SRC_URI="mirror://sourceforge/fldigi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

DOCS=(AUTHORS ChangeLog README)

RDEPEND="x11-libs/libX11
	x11-libs/fltk:1
	x11-misc/xdg-utils"

DEPEND="${RDEPEND}
	sys-devel/gettext"

PATCHES=( "${FILESDIR}/${PN}-1.4.4-musl.patch" )

src_prepare() {
	eapply ${PATCHES[@]}
	eapply_user
}

src_configure() {
	#fails to compile with -flto (bug #860408)
	filter-lto

	econf
}
