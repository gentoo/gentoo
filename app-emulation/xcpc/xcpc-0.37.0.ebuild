# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="XCPC is a portable Amstrad CPC 464/664/6128 emulator written in C."
HOMEPAGE="http://www.xcpc-emulator.net/doku.php/index"
SRC_URI="https://bitbucket.org/ponceto/xcpc/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-athena \
		--disable-motif2 \
		--with-x11-toolkit=gtk3
}
