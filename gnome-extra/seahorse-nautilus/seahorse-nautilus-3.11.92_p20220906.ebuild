# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson xdg

DESCRIPTION="Nautilus extension for encrypting and decrypting files with GnuPG"
HOMEPAGE="https://gitlab.gnome.org/GNOME/seahorse-nautilus"
COMMIT="2cc2a06148604b2f118ef460527b03d27530f6d4"
SHORT_COMMIT="2cc2a06"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${COMMIT}/${PN}-${SHORT_COMMIT}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	>=app-crypt/gpgme-1.0.0
	>=app-crypt/gcr-3.4:0=[gtk]
	>=dev-libs/dbus-glib-0.35
	>=dev-libs/glib-2.28:2
	gnome-base/gnome-keyring
	>=gnome-base/nautilus-43
	x11-libs/gtk+:3
	>=x11-libs/libcryptui-3.9.90
	>=x11-libs/libnotify-0.3:=
	>=app-crypt/gnupg-1.4
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	# Fix icon location, https://gitlab.gnome.org/GNOME/seahorse-nautilus/-/issues/10
	sed -i 's/pixmaps\/seahorse-plugins\/48x48/pixmaps\/cryptui\/48x48/' \
		tool/seahorse-notification.c || die
}

src_configure() {
	local emesonargs=(
		-Dcheck-compatible-gpg=false
		-Dlibnotify=true
	)
	meson_src_configure
}
