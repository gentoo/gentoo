# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-tools-backends/system-tools-backends-2.10.2.ebuild,v 1.12 2015/04/03 10:40:39 dlan Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 readme.gentoo user

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://projects.gnome.org/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="
	!<app-admin/gnome-system-tools-1.1.91
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.15.2:2
	>=dev-perl/Net-DBus-0.33.4
	dev-lang/perl
	>=sys-auth/polkit-0.94
	userland_GNU? ( virtual/shadow )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You need to add yourself to the group stb-admin and
add system-tools-backends to the default runlevel.
You can do this as root like so:
# rc-update add system-tools-backends default
"

pkg_setup() {
	enewgroup stb-admin
}

src_prepare() {
	# Change default permission, only people in stb-admin is allowed
	# to speak to the dispatcher.
	epatch "${FILESDIR}/${PN}-2.8.2-default-permissions.patch"

	# Apply fix from ubuntu for CVE 2008 4311
	epatch "${FILESDIR}/${PN}-2.8.2-cve-2008-4311.patch"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --localstatedir=/var
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
