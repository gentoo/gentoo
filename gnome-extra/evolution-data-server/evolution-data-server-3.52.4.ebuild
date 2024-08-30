# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake db-use flag-o-matic gnome2 vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://gitlab.gnome.org/GNOME/evolution/-/wikis/home https://gitlab.gnome.org/GNOME/evolution-data-server"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/64-11-21-4-3-27-2-27-4-0" # subslot = libcamel-1.2/libebackend-1.2/libebook-1.2/libebook-contacts-1.2/libecal-2.0/libedata-book-1.2/libedata-cal-2.0/libedataserver-1.2/libedataserverui-1.2/libedataserverui4-1.0 soname version

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="berkdb +gnome-online-accounts +gtk gtk-doc +introspection ldap kerberos oauth-gtk3 oauth-gtk4 vala +weather"
REQUIRED_USE="
	oauth-gtk3? ( gtk )
	oauth-gtk4? ( gtk )
	vala? ( introspection )
"

# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
# glib-2.70 for build-time optional GPowerProfileMonitor
RDEPEND="
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:3
	>=dev-libs/glib-2.70:2
	>=dev-libs/libical-3.0.8:=[glib,introspection?]
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4
	>=dev-libs/nss-3.9
	>=net-libs/libsoup-3.1.1:3.0
	>=dev-libs/json-glib-1.0.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=x11-libs/gtk+-3.20:3
		>=gui-libs/gtk-4.4:4
		>=media-libs/libcanberra-0.25[gtk3]

		oauth-gtk3? ( >=net-libs/webkit-gtk-2.34.0:4.1 )
		oauth-gtk4? ( >=net-libs/webkit-gtk-2.39.90:6 )
	)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-4.2.0:4= )
"
DEPEND="${RDEPEND}
	vala? ( $(vala_depend)
		>=net-libs/libsoup-3.1.1:3.0[vala]
		dev-libs/libical[vala]
	)
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gperf
	gtk-doc? (
		>=dev-util/gtk-doc-1.14
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.1.2
	)
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="!test? ( test )"

pkg_pretend() {
	if has_version "gnome-extra/evolution-data-server[oauth(-)]" &&
		! use oauth-gtk3 && ! use oauth-gtk4
	then
		ewarn "The previous installed version of gnome-extra/evolution-data-server"
		ewarn "had USE=oauth enabled that is now split into USE=oauth-gtk3"
		ewarn "and USE=oauth-gtk4.  Please consider enabling either (or both)"
		ewarn "of these flags to preserve OAuth2 support."
	fi
}

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare call
src_prepare() {
	use vala && vala_setup
	cmake_src_prepare
	gnome2_src_prepare

	eapply "${FILESDIR}"/3.36.5-gtk-doc-1.32-compat.patch

	# Make CMakeLists versioned vala enabled
	sed -e "s;\(find_program(VALAC\) valac);\1 ${VALAC});" \
	  -e "s;\(find_program(VAPIGEN\) vapigen);\1 ${VAPIGEN});" \
	  -i "${S}"/CMakeLists.txt || die
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	# phonenumber does not exist in tree
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
#		-DENABLE_GI_DOCGEN=$(usex gtk-doc)
		-DENABLE_GTK_DOC=$(usex gtk-doc)
		-DWITH_PRIVATE_DOCS=$(usex gtk-doc)
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DWITH_KRB5=$(usex kerberos)
		-DWITH_KRB5_INCLUDES=$(usex kerberos "${EPREFIX}"/usr "")
		-DWITH_KRB5_LIBS=$(usex kerberos "${EPREFIX}"/usr/$(get_libdir) "")
		-DWITH_OPENLDAP=$(usex ldap)
		-DWITH_PHONENUMBER=OFF
		-DENABLE_SMIME=ON
		-DENABLE_GTK=$(usex gtk)
		-DENABLE_GTK4=$(usex gtk)
		-DENABLE_CANBERRA=$(usex gtk)
		-DENABLE_OAUTH2_WEBKITGTK=$(usex oauth-gtk3)
		-DENABLE_OAUTH2_WEBKITGTK4=$(usex oauth-gtk4)
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr OFF)
		# ENABLE_BACKTRACES requires libdwarf ?
		-DENABLE_IPV6=ON
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym ../../../usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}
