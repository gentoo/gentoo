# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A tiny vt100 terminal emulator for X"
HOMEPAGE="ftp://ftp.x.org/R5contrib/xvt-1.0.README"
SRC_URI="ftp://ftp.x.org/R5contrib/xvt-1.0.tar.Z
		mirror://gentoo/xvt-2.1.diff.gz"

LICENSE="xvt"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${PN}-1.0

PATCHES=(
	# this brings the distribution upto version 2.1
	"${WORKDIR}"/${P}.diff

	# fix #61393
	"${FILESDIR}/${PN}-ttyinit-svr4pty.diff"

	# CFLAGS, CC #241554
	"${FILESDIR}/${PN}-makefile.patch"

	# int main, not void main
	"${FILESDIR}/${PN}-int-main.patch"

	# fix segfault (bug #363883)
	"${FILESDIR}/${PN}-pts.patch"
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin xvt
	doman xvt.1
	einstalldocs
}
