# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Gtk3 PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	media-libs/fontconfig
	>=x11-libs/gtk+-2:2
	>=x11-libs/gtk+-3:3
	x11-libs/pango
	~app-admin/packagekit-base-${PV}[introspection]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--disable-bash-completion \
		--disable-browser-plugin \
		--disable-command-not-found \
		--disable-cron \
		--disable-gstreamer-plugin \
		--disable-gtk-doc \
		--disable-local \
		--disable-man-pages \
		--disable-networkmanager \
		--disable-static \
		--disable-systemd \
		--disable-vala \
		--enable-dummy \
		--enable-gtk-module \
		--enable-introspection=yes \
		--localstatedir=/var
}

src_compile() {
	emake -C contrib/gtk-module
}

src_install() {
	emake -C contrib/gtk-module DESTDIR="${D}" install
	prune_libtool_files --all
}
