# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF=yes
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2

DESCRIPTION="NetworkManager OpenConnect plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager https://gitlab.gnome.org/GNOME/NetworkManager-openconnect"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="gtk"

DEPEND="
	>=net-misc/networkmanager-1.2:=
	>=dev-libs/glib-2.34:2
	>=dev-libs/dbus-glib-0.74
	dev-libs/libxml2:2
	dev-libs/glib:2
	>=net-vpn/openconnect-3.02:=
	gtk? (
		>=app-crypt/libsecret-0.18

		>=app-crypt/gcr-3.4:0=
		>=x11-libs/gtk+-3.12:3

		>=gui-libs/gtk-4.0:4
		>=net-libs/libnma-1.8.36
		net-libs/webkit-gtk:4.1
	)
"

RDEPEND="
	${DEPEND}
	acct-group/nm-openconnect
	acct-user/nm-openconnect
"

BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-check-webkit-if-gtk.patch
)

src_configure() {
	local myconf=(
		--disable-more-warnings
		--disable-static
		--without-libnm-glib
		$(use_with gtk gnome)
		$(use_with gtk authdlg)
		$(use_with gtk gtk4)
	)

	gnome2_src_configure "${myconf[@]}"
}
