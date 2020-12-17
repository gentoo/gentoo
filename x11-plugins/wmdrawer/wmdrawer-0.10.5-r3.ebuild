# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="dockapp which provides a drawer (retractable button bar) to launch applications"
HOMEPAGE="http://people.easter-eggs.org/~valos/wmdrawer/"
SRC_URI="http://people.easter-eggs.org/~valos/wmdrawer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/gdk-pixbuf-xlib
	>=x11-libs/gdk-pixbuf-2.42.0:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README TODO AUTHORS ChangeLog wmdrawerrc.example )
PATCHES=( "${FILESDIR}"/${P}-gtk+-2.patch )

src_prepare() {
	default

	gunzip doc/wmdrawer.1x.gz || die

	# Honour Gentoo CFLAGS
	sed -i -e "s|-O3|${CFLAGS}|" Makefile || die
	# Fix LDFLAGS ordering per bug #248640
	sed -i -e 's/$(CC) $(LDFLAGS) -o $@ $(OBJS)/$(CC) -o $@ $(OBJS) $(LDFLAGS)/' Makefile || die
	# Do not auto-strip binaries
	sed -i -e 's/	strip $@//' Makefile || die
	# Honour Gentoo LDFLAGS
	sed -i -e 's/$(CC) -o/$(CC) $(REAL_LDFLAGS) -o/' Makefile || die
}

src_compile() {
	emake REAL_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin wmdrawer
	doman doc/wmdrawer.1x
	einstalldocs
}
