# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="GTK2 WGet Frontend"
HOMEPAGE="https://gnome.org/projects/gwget/"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="epiphany libnotify"

# FIXME: dbus should be optional
#        needs patching for linguas/intltool
RDEPEND="
	net-misc/wget
	>=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.16.0:2
	>=gnome-base/gconf-2:2
	>=gnome-base/libgnomeui-2
	>=dev-libs/dbus-glib-0.70
	epiphany? ( >=www-client/epiphany-1.4 )
	libnotify? ( >=x11-libs/libnotify-0.2.2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0
	>=sys-devel/gettext-0.10.4
"

PATCHES=(
	"${FILESDIR}"/${P}-libnotify-0.7.patch
	"${FILESDIR}"/${P}-glib-single-include.patch
)

src_configure() {
	gnome2_src_configure \
		$(use_enable epiphany epiphany-extension) \
		$(use_enable libnotify) \
		--disable-static
}

src_install() {
	gnome2_src_install

	# remove /var/lib, which is created without any reason
	rm -rf "${D}"/var || die "rm failed"
}
