# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2 readme.gentoo-r1

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution https://gitlab.gnome.org/GNOME/evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"

IUSE="archive +bogofilter geolocation gtk-doc highlight ldap spamassassin spell ssl +weather ytnef"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
# dconf explicitely needed for backup plugin
# gnome-desktop support is optional with --enable-gnome-desktop
# automagic libunity dep
# >=gspell-1.8 to ensure it uses enchant:2 like webkit-gtk
DEPEND="
	>=app-text/enchant-2.2.0:2
	>=dev-db/sqlite-3.7.17
	>=dev-libs/glib-2.66:2[dbus]
	>=dev-libs/libxml2-2.7.3:2
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=gnome-extra/evolution-data-server-${PV}:=[gtk,weather?]
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/libsoup-3.0:3.0
	>=net-libs/webkit-gtk-2.38.0:4.1=[spell?]
	>=x11-libs/cairo-1.9.15[glib]
	>=x11-libs/gdk-pixbuf-2.24:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libnotify-0.7
	>=x11-misc/shared-mime-info-0.22

	app-text/cmark:=
	>=app-text/iso-codes-0.49
	|| ( >=app-accessibility/at-spi2-core-2.46.0:2 dev-libs/atk )

	gnome-base/dconf
	x11-libs/libSM
	x11-libs/libICE

	archive? ( >=app-arch/gnome-autoar-0.1.1[gtk] )
	bogofilter? ( mail-filter/bogofilter )
	geolocation? (
		>=media-libs/libchamplain-0.12:0.12[gtk]
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		>=sci-geosciences/geocode-glib-3.26.3:2 )
	ldap? ( >=net-nds/openldap-2:= )
	spamassassin? ( mail-filter/spamassassin )
	spell? ( >=app-text/gspell-1.8:= )
	ssl? (
		>=dev-libs/nspr-4.6.1
		>=dev-libs/nss-3.11
	)
	weather? (
		>=dev-libs/libgweather-4.2.0:4=
		>=sci-geosciences/geocode-glib-3.26.3:2
	)
	ytnef? ( net-mail/ytnef )
"
RDEPEND="${DEPEND}
	highlight? ( app-text/highlight )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To change the default browser if you are not using GNOME, edit
~/.local/share/applications/mimeapps.list so it includes the
following content:

[Default Applications]
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop

(replace firefox.desktop with the name of the appropriate .desktop
file from /usr/share/applications if you use a different browser)."

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare
# call; if needed, set them after cmake_src_prepare call, if that works

src_prepare() {
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_GTK_DOC=$(usex gtk-doc)
		-DWITH_OPENLDAP=$(usex ldap)
		-DENABLE_SMIME=$(usex ssl)
		-DENABLE_GNOME_DESKTOP=ON
		-DWITH_ENCHANT_VERSION=2
		-DENABLE_CANBERRA=ON
		-DENABLE_AUTOAR=$(usex archive)
		-DWITH_HELP=ON
		-DENABLE_YTNEF=OFF
		-DWITH_BOGOFILTER=$(usex bogofilter)
		-DWITH_SPAMASSASSIN=$(usex spamassassin)
		-DENABLE_GSPELL=$(usex spell)
		-DENABLE_TEXT_HIGHLIGHT=$(usex highlight)
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_CONTACT_MAPS=OFF # was $(usex geolocation), this will come back libchamplain gets it's libsoup3 port
		-DENABLE_YTNEF=$(usex ytnef)
		-DENABLE_PST_IMPORT=OFF
		-DWITH_GLADE_CATALOG=OFF
		-DENABLE_MARKDOWN=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	cmake_src_test
}

src_install() {
	cmake_src_install

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
