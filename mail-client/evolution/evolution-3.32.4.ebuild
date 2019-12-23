# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2 flag-o-matic readme.gentoo-r1

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"

IUSE="archive +bogofilter geolocation gtk-doc highlight ldap spamassassin spell ssl +weather ytnef"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
# dconf explicitely needed for backup plugin
# gnome-desktop support is optional with --enable-gnome-desktop
# automagic libunity dep
COMMON_DEPEND="
	>=app-crypt/gcr-3.4:=[gtk]
	>=app-text/enchant-1.6.0:0
	>=dev-libs/glib-2.46:2[dbus]
	>=dev-libs/libxml2-2.7.3:2
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=gnome-extra/evolution-data-server-${PV}:=[gtk,weather?]
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/libsoup-2.42:2.4
	>=net-libs/webkit-gtk-2.16.0:4
	<net-libs/webkit-gtk-2.25:4
	>=x11-libs/cairo-1.9.15:=[glib]
	>=x11-libs/gdk-pixbuf-2.24:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libnotify-0.7:=
	>=x11-misc/shared-mime-info-0.22

	>=app-text/iso-codes-0.49
	dev-libs/atk
	gnome-base/dconf
	>=dev-libs/libical-3.0.2:=
	x11-libs/libSM
	x11-libs/libICE

	archive? ( >=app-arch/gnome-autoar-0.1.1[gtk] )
	geolocation? (
		>=media-libs/libchamplain-0.12:0.12[gtk]
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		>=sci-geosciences/geocode-glib-3.10.0
		x11-libs/mx:1.0 )
	ldap? ( >=net-nds/openldap-2:= )
	spell? ( app-text/gtkspell:3 )
	ssl? (
		>=dev-libs/nspr-4.6.1:=
		>=dev-libs/nss-3.11:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
	ytnef? ( net-mail/ytnef )
"
DEPEND="${COMMON_DEPEND}
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
RDEPEND="${COMMON_DEPEND}
	bogofilter? ( mail-filter/bogofilter )
	highlight? ( app-text/highlight )
	spamassassin? ( mail-filter/spamassassin )
	!gnome-extra/evolution-exchange
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
# call; if needed, set them after cmake-utils_src_prepare call, if that works

src_prepare() {
	eapply "${FILESDIR}"/${PV}-gtk-doc-fix{1,2}.patch
	cmake-utils_src_prepare
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
		-DWITH_ENCHANT_VERSION=1
		-DENABLE_CANBERRA=ON
		-DENABLE_AUTOAR=$(usex archive)
		-DWITH_HELP=ON
		-DENABLE_YTNEF=OFF
		-DWITH_BOGOFILTER=$(usex bogofilter)
		-DWITH_SPAMASSASSIN=$(usex spamassassin)
		-DENABLE_GTKSPELL=$(usex spell)
		-DENABLE_TEXT_HIGHLIGHT=$(usex highlight)
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_CONTACT_MAPS=$(usex geolocation)
		-DENABLE_YTNEF=$(usex ytnef)
		-DENABLE_PST_IMPORT=OFF
		-DWITH_GLADE_CATALOG=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	# Problems with prelink:
	# https://bugzilla.gnome.org/show_bug.cgi?id=731680
	# https://bugzilla.gnome.org/show_bug.cgi?id=732148
	# https://bugzilla.redhat.com/show_bug.cgi?id=1114538
	echo PRELINK_PATH_MASK=/usr/bin/evolution > ${T}/99${PN}
	doenvd "${T}"/99${PN}

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
