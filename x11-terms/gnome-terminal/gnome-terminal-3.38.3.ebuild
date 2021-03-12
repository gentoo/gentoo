# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 readme.gentoo-r1

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug +gnome-shell +nautilus vanilla"
SRC_URI+=" !vanilla? ( https://dev.gentoo.org/~mattst88/distfiles/${PN}-3.38.1-cntr-ntfy-autottl-ts.patch.xz )"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

# FIXME: automagic dependency on gtk+[X], just transitive but needs proper control, bug 624960
RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.22.27:3
	>=x11-libs/vte-0.62.1:2.91[!vanilla?]
	>=dev-libs/libpcre2-10
	>=gnome-base/dconf-0.14
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-3.28.0 )
"
DEPEND="${RDEPEND}"
# itstool required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
BDEPEND="
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
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
		# Restore "Set title" support
		# Automatic title updating based on currently running foreground process
		# https://src.fedoraproject.org/rpms/gnome-terminal/raw/f31/f/gnome-terminal-cntr-ntfy-autottl-ts.patch
		# Depends on vte[-vanilla] for OSC 777 and the preexec/precmd/etc patches in VTE
		eapply "${WORKDIR}"/${PN}-3.38.1-cntr-ntfy-autottl-ts.patch
	fi
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable debug) \
		$(use_enable gnome-shell search-provider) \
		$(use_with nautilus nautilus-extension)
}

src_install() {
	DOCS=( AUTHORS ChangeLog HACKING NEWS )
	gnome2_src_install
	if ! use vanilla; then
		# Separate "New Window/Tab" menu entries by default, instead of unified "New Terminal"
		insinto /usr/share/glib-2.0/schemas
		newins "${FILESDIR}"/separate-new-tab-window.gschema.override org.gnome.Terminal.gschema.override
	fi
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
