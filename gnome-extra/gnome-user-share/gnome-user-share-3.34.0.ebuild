# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson multilib systemd xdg

DESCRIPTION="Personal file sharing for the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-user-share"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

# FIXME: could libnotify be made optional ?
# FIXME: selinux automagic support
RDEPEND="
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3:3
	>=gnome-base/nautilus-3.27.90
	>=www-apache/mod_dnssd-0.6
	>=www-servers/apache-2.2[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Upstream forces to use prefork because of Fedora defaults, but
	# that is problematic for us (bug #551012)
	# https://bugzilla.gnome.org/show_bug.cgi?id=750525#c2
	"${FILESDIR}"/${PN}-3.18.1-no-prefork.patch
)

src_configure() {
	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dhttpd=apache2
		-Dmodules_path=/usr/$(get_libdir)/apache2/modules/
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
