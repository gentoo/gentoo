# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/notecase/notecase-1.9.8-r1.ebuild,v 1.1 2014/05/14 16:36:35 tomwij Exp $

EAPI="5"

inherit eutils fdo-mime

DESCRIPTION="Hierarchical note manager written using GTK+ and C++"
HOMEPAGE="http://notecase.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}_src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome nls"

RDEPEND="sys-libs/zlib:0
	>=x11-libs/gtk+-2.6:2
	x11-libs/libX11:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig:*"

# test doesn't work
RESTRICT="test"

src_prepare() {
	# Respect CFLAGS and don't use --as-needed by default
	epatch "${FILESDIR}/notecase-1.7.2-CFLAGS.patch"
	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-gtksourceview.patch

	if ! use gnome; then
		# Comment variable in the Makefile if we don't have gnome
		sed -i -e 's/HAVE_GNOME_VFS=1/#HAVE_GNOME_VFS=1/g' \
				-e 's/AUTODETECT_GNOME_VFS=1/#AUTODETECT_GNOME_VFS=1/g' \
			 Makefile || die "gnome sed failed"
	fi

	! use nls && {
		sed -i -e 's/notecase$(EXE) poinstall/notecase$(EXE)/g' \
			Makefile || die "nls sed failed"
		}

	# Verbose building, fix as-needed support and missing libs.
	sed -e 's/^\(Q[CL]*=\)@.*$/\1/' \
		-e 's:\(-o $(BIN)/notecase$(EXE) .*\) \($(GTKLIBS)\):\2 -lX11 -lz \1:' \
		-i Makefile || die

	# Remove Application category from .desktop file.
	sed -i 's/^\(Categories=\)Application;/\1/' docs/notecase.desktop || die
}

src_compile() {
	emake -j1
}

src_install() {
	default

	dodoc readme.txt
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
