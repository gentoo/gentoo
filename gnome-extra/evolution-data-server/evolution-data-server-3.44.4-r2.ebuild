# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake db-use flag-o-matic gnome2 vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution https://gitlab.gnome.org/GNOME/evolution-data-server"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/63-26-20" # subslot = libcamel-1.2/libedataserver-1.2/libebook-1.2.so soname version

IUSE="berkdb +gnome-online-accounts +gtk gtk-doc +introspection ipv6 ldap kerberos oauth vala +weather"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

# gdata-0.17.7 soft required for new gdata_feed_get_next_page_token API to handle more than 100 google tasks
# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
# glib-2.70 for build-time optional GPowerProfileMonitor
# <libgweather-4.2.0 because of libsoup:3 transition
gdata_depend=">=dev-libs/libgdata-0.17.7:="
RDEPEND="
	>=app-crypt/gcr-3.4:0=
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17
	>=dev-libs/glib-2.70:2
	>=dev-libs/libical-3.0.8:=[glib,introspection?]
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4
	>=dev-libs/nss-3.9
	>=net-libs/libsoup-2.58:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4:0=[gtk]
		>=x11-libs/gtk+-3.16:3
		>=media-libs/libcanberra-0.25[gtk3]
	)
	oauth? (
		>=dev-libs/json-glib-1.0.4
		>=net-libs/webkit-gtk-2.28.0:4
		${gdata_depend}
	)
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.8:=
		${gdata_depend} )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? (
		>=dev-libs/libgweather-3.91.0:4=
		<dev-libs/libgweather-4.2.0:4=
	)
"
DEPEND="${RDEPEND}
	vala? ( $(vala_depend)
		net-libs/libsoup:2.4[vala]
		dev-libs/libical[vala]
		oauth? ( dev-libs/libgdata[vala] )
		gnome-online-accounts? ( dev-libs/libgdata[vala] )
	)
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gperf
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.1.2 )
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="test !test? ( test )"

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

	local google_enable
	if use oauth || use gnome-online-accounts; then
		google_enable="ON"
	else
		google_enable="OFF"
	fi

	# phonenumber does not exist in tree
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
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
		-DENABLE_CANBERRA=$(usex gtk)
		-DENABLE_OAUTH2=$(usex oauth)
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr OFF)
		# ENABLE_BACKTRACES requires libdwarf ?
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_WEATHER=$(usex weather)
		-DWITH_GWEATHER4=ON
		-DENABLE_GOOGLE=${google_enable}
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
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
