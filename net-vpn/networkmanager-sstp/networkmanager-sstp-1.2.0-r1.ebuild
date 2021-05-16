# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="NetworkManager-sstp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling Protocol(SSTP)"
HOMEPAGE="https://sourceforge.net/projects/sstp-client/"
SRC_URI="mirror://sourceforge/project/sstp-client/network-manager-sstp/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	>=dev-libs/glib-2.32:2
	net-misc/sstp-client
	>=net-misc/networkmanager-1.1.0
	net-dialup/ppp:=
	gtk? (
		>=x11-libs/gtk+-3.4:3
		>=net-libs/libnma-1.1.0
		app-crypt/libsecret
	)
"

DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
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
		 $(use_with gtk gnome) \
		 --without-libnm-glib
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
