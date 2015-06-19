# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/packagekit-gtk/packagekit-gtk-0.8.15.ebuild,v 1.3 2013/12/24 10:54:15 lxnay Exp $

EAPI="3"

inherit eutils base

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Gtk3 PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	media-libs/fontconfig
	>=x11-libs/gtk+-3.0:3
	x11-libs/pango
	~app-admin/packagekit-base-${PV}"
DEPEND="${RDEPEND} virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--disable-bash-completion \
		--disable-browser-plugin \
		--disable-command-not-found \
		--disable-cron \
		--disable-debuginfo-install \
		--disable-dependency-tracking \
		--disable-gstreamer-plugin \
		--disable-gtk-doc \
		--disable-local \
		--disable-man-pages \
		--disable-networkmanager \
		--disable-systemd \
		--disable-systemd-updates \
		--enable-dummy \
		--enable-gtk-module \
		--enable-introspection=yes \
		--enable-libtool-lock \
		--enable-option-checking \
		--localstatedir=/var
}

src_compile() {
	cd "${S}"/contrib/gtk-module || die
	emake || die "emake install failed"
}

src_install() {
	cd "${S}"/contrib/gtk-module || die
	emake DESTDIR="${D}" install || die "emake install failed"
}
