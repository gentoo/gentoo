# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Yelp"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	app-arch/bzip2:=
	>=app-arch/xz-utils-4.9:=
	dev-db/sqlite:3=
	>=dev-libs/glib-2.38:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=gnome-extra/yelp-xsl-3.12
	>=net-libs/webkit-gtk-2.7.2:4
	>=x11-libs/gtk+-3.13.3:3
	x11-themes/adwaita-icon-theme
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	# Fix compatibility with Gentoo's sys-apps/man
	# https://bugzilla.gnome.org/show_bug.cgi?id=648854
	eapply "${FILESDIR}"/${PN}-3.20.0-man-compatibility.patch
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-bz2 \
		--enable-lzma
}

src_install() {
	gnome2_src_install
	exeinto /usr/libexec/
	doexe "${S}"/libyelp/yelp-groff
}
