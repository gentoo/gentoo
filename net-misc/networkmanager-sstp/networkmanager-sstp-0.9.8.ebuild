# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-sstp/networkmanager-sstp-0.9.8.ebuild,v 1.2 2014/06/24 01:21:42 tetromino Exp $

EAPI=5

inherit eutils multilib

MY_PN="NetworkManager-sstp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling Protocol(SSTP)"
HOMEPAGE="http://sourceforge.net/projects/sstp-client/"
SRC_URI="mirror://sourceforge/project/sstp-client/network-manager-sstp/${PV}-1/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND=">=dev-libs/dbus-glib-0.74
	net-misc/sstp-client
	>=net-misc/networkmanager-${PV}
	net-dialup/ppp:=
	gtk? (
		x11-libs/gtk+:3
		gnome-base/gnome-keyring
		gnome-base/libgnome-keyring
	)
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PPPD_VERSION="$(echo $(best_version net-dialup/ppp) | sed -e 's:net-dialup/ppp-\(.*\):\1:' -e 's:-r.*$::')"
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		--with-pppd-plugin-dir="${EPREFIX}/usr/$(get_libdir)/pppd/${PPPD_VERSION}" \
		--with-gtkver=3 \
		 $(use_with gtk gnome)
}

src_install() {
	default
	prune_libtool_files
}
