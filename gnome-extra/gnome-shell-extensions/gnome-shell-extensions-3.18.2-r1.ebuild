# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2 readme.gentoo

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell/Extensions"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26:2
	>=gnome-base/libgtop-2.28.3[introspection]
	>=app-eselect/eselect-gnome-shell-extensions-20111211
"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection:=
	dev-libs/atk[introspection]
	gnome-base/gnome-menus:3[introspection]
	>=gnome-base/gnome-shell-3.14.2
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs gnome-base/gnome-common

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Installed extensions installed are initially disabled by default.
To change the system default and enable some extensions, you can use
# eselect gnome-shell-extensions

Alternatively, to enable/disable extensions on a per-user basis,
you can use the https://extensions.gnome.org/ web interface, the
gnome-extra/gnome-tweak-tool GUI, or modify the org.gnome.shell
enabled-extensions gsettings key from the command line or a script."

src_prepare() {
	# Revert commit because of https://bugs.gentoo.org/show_bug.cgi?id=567126
	# https://bugzilla.gnome.org/show_bug.cgi?id=759879
	epatch -R "${FILESDIR}"/${PN}-3.18.2-revert-encodings.patch
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --enable-extensions=all
}

src_install() {
	gnome2_src_install

	local example="example@gnome-shell-extensions.gcampax.github.com"
	if use examples; then
		mv "${ED}usr/share/gnome-shell/extensions/${example}" \
			"${ED}usr/share/doc/${PF}/" || die
	else
		rm -r "${ED}usr/share/gnome-shell/extensions/${example}" || die
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	readme.gentoo_print_elog
}
