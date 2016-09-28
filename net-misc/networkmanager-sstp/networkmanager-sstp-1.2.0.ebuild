# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_PN="NetworkManager-sstp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling Protocol(SSTP)"
HOMEPAGE="https://sourceforge.net/projects/sstp-client/"
SRC_URI="mirror://sourceforge/project/sstp-client/network-manager-sstp/${PV}/${MY_P}.tar.bz2"

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
		 $(use_with gtk gnome)
}

src_install() {
	default
	prune_libtool_files
}
