# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager PPTP plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-0.9.10:=
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32:2
	net-dialup/ppp:=
	net-dialup/pptpclient
	gtk? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-1.0.5
		>=x11-libs/gtk+-3.4:3
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

src_configure() {
	local myconf
	# Same hack as net-dialup/pptpd to get proper plugin dir for ppp, bug #519986
	local PPPD_VER=`best_version net-dialup/ppp`
	PPPD_VER=${PPPD_VER#*/*-} #reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*} # main version without beta/pre/patch/revision
	myconf="${myconf} --with-pppd-plugin-dir=/usr/$(get_libdir)/pppd/${PPPD_VER}"

	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome) \
		${myconf}
}
