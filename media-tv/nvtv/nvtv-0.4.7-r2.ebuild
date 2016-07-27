# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

IUSE="X gtk"

DESCRIPTION="TV-Out for NVidia cards"
HOMEPAGE="https://sourceforge.net/projects/nv-tv-out/"
SRC_URI="mirror://sourceforge/nv-tv-out/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

RDEPEND="sys-apps/pciutils[-zlib]
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xf86vidmodeproto )"

src_configure() {
	local myconf

	if use gtk
	then
		myconf="${myconf} --with-gtk"
	else
		myconf="${myconf} --without-gtk"
	fi

	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"

	econf ${myconf}
}

src_compile() {
	# The CFLAGS don't seem to make it into the Makefile.
	cd src
	emake CXFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/nvtv
	dosbin src/nvtvd

	dodoc ANNOUNCE BUGS FAQ INSTALL README \
		doc/USAGE doc/chips.txt doc/overview.txt \
		doc/timing.txt xine/tvxine

	newinitd "${FILESDIR}"/nvtv.start nvtv
}
