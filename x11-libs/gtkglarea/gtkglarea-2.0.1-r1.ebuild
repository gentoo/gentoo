# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglarea/gtkglarea-2.0.1-r1.ebuild,v 1.11 2013/04/10 20:22:16 ago Exp $

EAPI="5"

GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="OpenGL canvas and context provider for GTK+"
HOMEPAGE="http://www.mono-project.com/GtkGLArea"

LICENSE="LGPL-2+ GPL-2+" # examples are GPL-2+, library is LGPL-2+
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND=">=x11-libs/gtk+-2.0.3:2
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Do not build examples
	sed "s:\(SUBDIRS.*\)examples:\1:" -i Makefile.am Makefile.in || die "sed 1 failed"
	# -lGLU is only needed for building examples. Avoid autoreconf.
	sed -e 's: -lGLU::' -i configure || die "sed 2 failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README* docs/*.txt"
	gnome2_src_install

	if use examples; then
		cd "${S}"/examples
		insinto /usr/share/doc/${PF}/examples
		doins *.c *.h *.lwo README || die "doins failed"
	fi
}
