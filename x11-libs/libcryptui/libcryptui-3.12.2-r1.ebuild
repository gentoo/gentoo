# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="User interface components for OpenPGP"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1"
SLOT="0"
IUSE="debug +introspection libnotify"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 x86"

# Pull in libnotify-0.7 because it's controlled via an automagic ifdef
COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3:3[introspection?]
	>=dev-libs/dbus-glib-0.72
	>=app-crypt/gcr-3[gtk]
	x11-libs/libICE
	x11-libs/libSM

	>=app-crypt/gpgme-1:1=
	>=app-crypt/gnupg-1.4

	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
"
DEPEND="${COMMON_DEPEND}
	app-text/rarian
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# Before 3.1.4, libcryptui was part of seahorse
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-3.1.4
"

PATCHES=(
	# Support GnuPG 2.1, in master
	# https://bugzilla.gnome.org/show_bug.cgi?id=745843
	"${FILESDIR}"/${PN}-3.12.2-gnupg-2.1.patch
	# from master, in Debian as well
	"${FILESDIR}"/${PN}-3.12.2-prompt-recipient.patch
	"${FILESDIR}"/${PN}-3.12.2-fix-return-types.patch
	"${FILESDIR}"/${PN}-3.12.2-port-gcr-3.patch
	# Support GnuPG 2.2
	# https://bugs.gentoo.org/show_bug.cgi?id=629572
	"${FILESDIR}"/${PN}-3.12.2-gnupg-2.2.patch
)

src_prepare() {
	# FIXME: Do not mess with CFLAGS with USE="debug"
	sed -e '/CFLAGS="$CFLAGS -g -O0/d' \
		-e 's/-Werror//' \
		-i configure.ac configure || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-update-mime-database \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_enable libnotify)
}
