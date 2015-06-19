# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.32.1-r1.ebuild,v 1.10 2015/01/07 20:01:30 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 eutils

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://library.gnome.org/devel/libgnome/stable/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="branding"

SRC_URI="${SRC_URI}
	branding? ( mirror://gentoo/gentoo-gdm-theme-r3.tar.bz2 )"

RDEPEND="
	>=gnome-base/gconf-2
	>=dev-libs/glib-2.16:2
	>=gnome-base/gnome-vfs-2.5.3
	>=gnome-base/libbonobo-2.13
	>=dev-libs/popt-1.7
	media-libs/libcanberra
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

PDEPEND="gnome-base/gvfs"

src_prepare() {
	# Make sure menus have icons. People don't like change
	epatch "${FILESDIR}/${PN}-2.28.0-menus-have-icons.patch"

	use branding && epatch "${FILESDIR}"/${PN}-2.26.0-branding.patch

	# Default to Adwaita theme over Clearlooks to proper gtk3 support
	sed -i -e 's/Clearlooks/Adwaita/' schemas/desktop_gnome_interface.schemas.in.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-canberra \
		--disable-esd
}

src_install() {
	gnome2_src_install

	if use branding; then
		# Add gentoo backgrounds
		dodir /usr/share/pixmaps/backgrounds/gnome/gentoo
		insinto /usr/share/pixmaps/backgrounds/gnome/gentoo
		doins "${WORKDIR}"/gentoo-emergence/gentoo-emergence.png
		doins "${WORKDIR}"/gentoo-cow/gentoo-cow-alpha.png
	fi
}
