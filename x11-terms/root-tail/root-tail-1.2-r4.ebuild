# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Terminal to display (multiple) log files on the root window"
HOMEPAGE="http://oldhome.schmorp.de/marc/root-tail.html"
SRC_URI="http://oldhome.schmorp.de/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="kde debug"

RDEPEND="x11-libs/libXext
	x11-libs/libX11"
DEPEND="x11-misc/imake
	app-text/rman
	x11-base/xorg-proto
	x11-libs/libX11
	x11-misc/gccmakedep"

src_prepare() {
	use kde && eapply "${FILESDIR}"/${P}-kde.patch
	default
}

src_configure() {
	xmkmf -a
}

src_compile() {
	sed -i 's:/usr/X11R6/bin:/usr/bin:' Makefile || die "sed Makefile failed"
	use debug && append-flags -DDEBUG
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install install.man
	dodoc Changes README
}
