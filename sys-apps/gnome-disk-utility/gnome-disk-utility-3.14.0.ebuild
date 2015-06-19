# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gnome-disk-utility/gnome-disk-utility-3.14.0.ebuild,v 1.3 2015/03/15 13:33:09 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="Disk Utility for GNOME using udisks"
HOMEPAGE="http://git.gnome.org/browse/gnome-disk-utility"

LICENSE="GPL-2+"
SLOT="0"
IUSE="fat +gnome systemd"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.31:2
	>=sys-fs/udisks-2.1.1:2
	>=x11-libs/gtk+-3.12:3
	>=app-arch/xz-utils-5.0.5
	>=app-crypt/libsecret-0.7
	dev-libs/libpwquality
	systemd? ( >=sys-apps/systemd-44:0= )
"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/libdvdread-4.2.0
	>=media-libs/libcanberra-0.1[gtk3]
	>=x11-libs/libnotify-0.7:=
	>=x11-themes/gnome-icon-theme-symbolic-2.91
	fat? ( sys-fs/dosfstools )
	gnome? ( >=gnome-base/gnome-settings-daemon-3.8 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	dev-libs/libxslt
	gnome-base/gnome-common
	virtual/pkgconfig
"

src_prepare() {
	# Fix USE=-gnome, bug #478820
	epatch "${FILESDIR}"/${PN}-3.10.0-kill-gsd-automagic.patch
	epatch "${FILESDIR}"/${PN}-3.10.0-raise-gsd-dependency.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable gnome gsd-plugin) \
		$(use_enable systemd libsystemd-login)
}
