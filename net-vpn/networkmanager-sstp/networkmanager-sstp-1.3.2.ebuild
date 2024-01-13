# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="NetworkManager-sstp"
MY_P="${MY_PN}-${PV}"
GNOME_ORG_MODULE="${MY_PN}"

inherit autotools gnome.org

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling Protocol(SSTP)"
HOMEPAGE="https://gitlab.gnome.org/GNOME/network-manager-sstp https://sourceforge.net/projects/sstp-client/"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui gtk4"

# As of 1.3.0, if want GUI support, GTK 3 is always needed, even with GTK 4.
# atk/graphene/harfbuzz/cairo/gdk-pixbuf/pango are all standard "dragged in by gtk/glib"
# deps.
RDEPEND="
	>=dev-libs/glib-2.32:2
	net-misc/sstp-client
	>=net-misc/networkmanager-1.1.0
	net-dialup/ppp:=
	net-libs/gnutls:=
	gui? (
		>=net-libs/libnma-1.8.0
		>=app-crypt/libsecret-0.18
		>=x11-libs/gtk+-3.4:3

		gtk4? (
			>=app-accessibility/at-spi2-core-2.46.0
			media-libs/graphene
			media-libs/harfbuzz:=
			x11-libs/cairo
			x11-libs/gdk-pixbuf:2
			x11-libs/pango

			gui-libs/gtk:4
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	sys-apps/file
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default

	# Bug #741108
	sed -i 's|/appdata|/metainfo|g' Makefile.{in,am} || die

	eautoreconf
}

src_configure() {
	local PPPD_VER="$(best_version net-dialup/ppp)"
	# Reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER#*/*-}
	# Main version without beta/pre/patch/revision
	PPPD_VER=${PPPD_VER%%[_-]*}

	econf \
		--disable-more-warnings \
		--with-dist-version=Gentoo \
		--with-pppd-plugin-dir="${EPREFIX}/usr/$(get_libdir)/pppd/${PPPD_VER}" \
		$(use_with gui gnome) \
		$(use_with gtk4)
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
