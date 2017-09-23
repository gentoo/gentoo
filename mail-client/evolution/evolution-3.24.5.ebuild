# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit cmake-utils gnome2 flag-o-matic readme.gentoo-r1

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"

IUSE="archive +bogofilter crypt geolocation highlight ldap spamassassin spell ssl +weather"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~x86"

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gnome-keyring] app-crypt/pinentry[gtk] app-crypt/pinentry[qt4] app-crypt/pinentry[qt5] )"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
# dconf explicitely needed for backup plugin
# gnome-desktop support is optional with --enable-gnome-desktop
COMMON_DEPEND="
	>=app-crypt/gcr-3.4:=[gtk]
	>=app-text/enchant-1.1.7
	>=dev-libs/glib-2.46:2[dbus]
	>=dev-libs/libxml2-2.7.3:2
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=gnome-extra/evolution-data-server-${PV}:=[gtk,weather?]
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/libsoup-2.42:2.4
	>=net-libs/webkit-gtk-2.13.90:4
	>=x11-libs/cairo-1.9.15:=[glib]
	>=x11-libs/gdk-pixbuf-2.24:2
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/libnotify-0.7:=
	>=x11-misc/shared-mime-info-0.22

	>=app-text/iso-codes-0.49
	dev-libs/atk
	gnome-base/dconf
	dev-libs/libical:=
	x11-libs/libSM
	x11-libs/libICE

	archive? ( >=app-arch/gnome-autoar-0.1.1[gtk] )
	crypt? (
		>=app-crypt/gnupg-1.4
		${PINENTRY_DEPEND}
		x11-libs/libcryptui )
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
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
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

src_prepare() {
	# Leave post-install actions to eclass
	sed -e "s;\(find_program(GTK_UPDATE_ICON_CACHE\).*;\1 $(type -P true));" \
		-i "${S}"/cmake/modules/IconCache.cmake || die

	gnome2_src_prepare
}

src_configure() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	local mycmakeargs=(
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_GTK_DOC=OFF
		-DWITH_OPENLDAP=$(usex ldap)
		-DENABLE_SMIME=$(usex ssl)
		-DENABLE_GNOME_DESKTOP=ON
		-DENABLE_CANBERRA=ON
		-DENABLE_AUTOAR=$(usex archive)
		-DWITH_HELP=ON
		-DENABLE_LIBCRYPTUI=$(usex crypt)
		-DENABLE_YTNEF=OFF
		-DWITH_BOGOFILTER=$(usex bogofilter)
		-DWITH_SPAMASSASSIN=$(usex spamassassin)
		-DENABLE_GTKSPELL=$(usex spell)
		-DENABLE_TEXT_HIGHLIGHT=$(usex highlight)
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_CONTACT_MAPS=$(usex geolocation)
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
