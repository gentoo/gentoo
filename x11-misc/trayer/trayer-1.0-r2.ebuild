# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Lightweight GTK+ based systray for UNIX desktop"
HOMEPAGE="http://home.gna.org/fvwm-crystal/"
SRC_URI="http://download.gna.org/fvwm-crystal/trayer/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	# fix for as-needed, bug #141707
	# fix pre-stripped files, bug #252098
	sed -i Makefile \
		-e 's:$(LIBS) $(OBJ) $(SYSTRAYOBJ):$(OBJ) $(SYSTRAYOBJ) $(LIBS):' \
		-e 's:strip:true:g' \
		|| die
	# fix underlinking, bug #369591
	sed -i Makefile.common \
		-e '/^LIBS/s:).*: x11):' \
		-e '/^INC/s:).*: x11):' \
		|| die
}

src_compile() {
	emake -j1 CC=$(tc-getCC) CFLAGS="${CFLAGS}" CPPFLAGS="${CPPFLAGS}"
}

src_install() {
	dobin trayer
	doman trayer.1
	einstalldocs
}
