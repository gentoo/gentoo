# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="blackbox mail notification"
HOMEPAGE="https://sourceforge.net/projects/bbtools"
SRC_URI="https://downloads.sourceforge.net/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-lang/perl
	x11-wm/blackbox
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-gcc4.3.patch
	"${FILESDIR}"/${P}-gcc4.4.patch
	"${FILESDIR}"/${P}-shebang.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dobin scripts/bbmailparsefm.pl
}
