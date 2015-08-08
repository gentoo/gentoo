# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 systemd udev

DESCRIPTION="WebDav server implementation using libsoup"
HOMEPAGE="https://wiki.gnome.org/phodav"

LICENSE="LGPL-2.1+"
SLOT="1.0"
KEYWORDS="alpha amd64 arm ppc ppc64 x86"
IUSE="avahi spice systemd"

RDEPEND="
	dev-libs/glib:2
	net-libs/libsoup:2.4
	dev-libs/libxml2
	avahi? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_with avahi) \
		--with-udevdir=$(get_udevdir) \
		--with-systemdsystemunitdir=$(systemd_get_unitdir)

	if ! use avahi ; then
		sed -i -e 's|avahi-daemon.service||' data/spice-webdavd.service || die
	fi
}

src_install() {
	gnome2_src_install

	if use spice ; then
		if ! use systemd ; then
			newinitd "${FILESDIR}/spice-webdavd.initd" spice-webdavd
			udev_dorules "${FILESDIR}/70-spice-webdavd.rules"
			rm -r "${D}$(systemd_get_unitdir)" || die
		fi
	else
		rm -r "${D}"{/usr/sbin,$(get_udevdir),$(systemd_get_unitdir)} || die
	fi
}
