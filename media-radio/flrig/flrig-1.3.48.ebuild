# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

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

src_prepare() {
	eapply_user
	eapply -p0 "${FILESDIR}"/fix-bashism.patch
	eautoreconf
}
