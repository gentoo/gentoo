# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 readme.gentoo-r1

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug +gnome-shell +nautilus vanilla"
SRC_URI="${SRC_URI} !vanilla? ( https://dev.gentoo.org/~leio/distfiles/gnome-terminal-notify-open-title-transparency.patch.xz )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

# FIXME: automagic dependency on gtk+[X], just transitive but needs proper control
# Needed vte in 3.24.2 is 0.48.2, but we add desktop notification patches in 0.48.3 that non-vanilla needs
RDEPEND="
	>=dev-libs/glib-2.42:2[dbus]
	>=x11-libs/gtk+-3.20:3[X]
	>=x11-libs/vte-0.48.3:2.91[!vanilla?]
	>=dev-libs/libpcre2-10
	>=gnome-base/dconf-0.14
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-3 )
"
# itstool/yelp-tools required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened tab, or
	notifications of long-running commands finishing, you will need
	to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte-2.91.sh"

src_prepare() {
	if ! use vanilla; then
		# https://bugzilla.gnome.org/show_bug.cgi?id=695371
		# Fedora patches:
		# Restore transparency support (with compositing WMs only)
		# OSC 777 desktop notification support (notifications on tabs for long-running commands completing)
		# Restore separate menuitems for opening tabs and windows
		# Restore "Set title" support
		# http://pkgs.fedoraproject.org/cgit/rpms/gnome-terminal.git/plain/gnome-terminal-notify-open-title-transparency.patch
		# Depends on vte[-vanilla] for OSC 777 patch in VTE
		eapply "${WORKDIR}"/${PN}-notify-open-title-transparency.patch
	fi
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-migration \
		$(use_enable debug) \
		$(use_enable gnome-shell search-provider) \
		$(use_with nautilus nautilus-extension) \
		VALAC=$(type -P true)
}

src_install() {
	DOCS="AUTHORS ChangeLog HACKING NEWS"
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
