# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME_ORG_MODULE="murrine"

inherit gnome.org multilib-minimal

DESCRIPTION="Murrine GTK+2 Cairo Engine"

HOMEPAGE="http://www.cimitan.com/murrine/"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="+themes animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.32.4[${MULTILIB_USEDEP}]
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"
PDEPEND="themes? ( x11-themes/murrine-themes )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

DOCS="AUTHORS ChangeLog NEWS TODO"

src_prepare() {
	# Linking fix, in next release (commit 6e8eb244). Sed to avoid eautoreconf.
	sed -e 's:\($(GTK_LIBS) $(pixman_LIBS)\)$:\1 -lm:' \
		-i Makefile.* || die "sed failed"
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf --enable-animation \
		--enable-rgba \
		$(use_enable animation-rtl animationrtl)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
}
