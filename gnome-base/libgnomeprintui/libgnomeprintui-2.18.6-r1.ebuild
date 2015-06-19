# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprintui/libgnomeprintui-2.18.6-r1.ebuild,v 1.9 2014/10/11 12:13:12 maekke Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 multilib-minimal

DESCRIPTION="User interface libraries for gnome print"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6:2[${MULTILIB_USEDEP}]
	>=gnome-base/libgnomeprint-2.12.1[${MULTILIB_USEDEP}]
	>=gnome-base/libgnomecanvas-1.117[${MULTILIB_USEDEP}]
	>=x11-themes/gnome-icon-theme-1.1.92"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

src_prepare() {
	gnome2_src_prepare

	# Drop DEPRECATED flags, bug #384815
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		libgnomeprintui/gpaui/Makefile.am libgnomeprintui/gpaui/Makefile.in \
		libgnomeprintui/Makefile.am libgnomeprintui/Makefile.in \
		tests/Makefile.am tests/Makefile.in || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README"
	einstalldocs
}
