# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="blackbox mail notification"
HOMEPAGE="https://sourceforge.net/projects/bbtools"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-lang/perl
	x11-wm/blackbox
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}"/${P}-gcc4.3.patch
	"${FILESDIR}"/${P}-gcc4.4.patch
	"${FILESDIR}"/${P}-shebang.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install () {
	default
	dobin scripts/bbmailparsefm.pl
}
