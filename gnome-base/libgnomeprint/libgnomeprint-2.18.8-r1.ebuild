# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprint/libgnomeprint-2.18.8-r1.ebuild,v 1.9 2014/10/11 12:12:34 maekke Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="Printer handling for Gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="cups doc"

RDEPEND=">=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}]
	>=media-libs/libart_lgpl-2.3.21-r2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	cups? (
		>=net-print/cups-1.7.1-r1[${MULTILIB_USEDEP}]
		>=net-print/libgnomecups-0.2.3-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	sys-devel/flex
	sys-devel/bison
	doc? (
		~app-text/docbook-xml-dtd-4.1.2
		>=dev-util/gtk-doc-0.9 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-stdio-include.patch \
		"${FILESDIR}"/${P}-freetype-2.5.1.patch \
		"${FILESDIR}"/${P}-bison3.patch \
		"${FILESDIR}"/${P}-cups-config.patch
	eautoreconf
	gnome2_src_prepare

	# Drop DEPRECATED flags, bug #384807
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED::g' \
		configure.in configure || die
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		libgnomeprint/ttsubset/Makefile.am \
		libgnomeprint/ttsubset/Makefile.in || die
}

multilib_src_configure() {
	# Disable papi support until papi is in portage; avoids automagic
	# dependencies on an untracked library.

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_with cups) \
		--without-papi \
		--disable-static
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS BUGS ChangeLog* NEWS README"
	einstalldocs
}
