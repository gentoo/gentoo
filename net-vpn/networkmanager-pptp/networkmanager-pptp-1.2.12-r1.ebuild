# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager PPTP VPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager/VPN"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-1.2.0:=
	>=dev-libs/glib-2.34:2
	net-dialup/ppp:=
	net-dialup/pptpclient
	gtk? (
		>=x11-libs/gtk+-3.4:3

		>=app-crypt/libsecret-0.18

		>=gui-libs/gtk-4.0:4
		>=net-libs/libnma-1.8.36
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/glib
	dev-util/gdbus-codegen
	sys-devel/gettext
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
		$(use_with gtk gtk4) \
		${myconf}
}
