# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )
VALA_USE_DEPEND="vapigen"

inherit cmake-utils db-use flag-o-matic gnome2 python-any-r1 systemd vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/60" # subslot = libcamel-1.2 soname version

IUSE="api-doc-extras berkdb +gnome-online-accounts +gtk google +introspection ipv6 ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"

# sys-libs/db is only required for migrating from <3.13 versions
# gdata-0.17.7 soft required for new gdata_feed_get_next_page_token API to handle more than 100 google tasks
# berkdb needed only for migrating old calendar data, bug #519512
gdata_depend=">=dev-libs/libgdata-0.17.7:="
RDEPEND="
	>=app-crypt/gcr-3.4
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.46:2
	>=dev-libs/libical-0.43:=
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=net-libs/libsoup-2.42:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4[gtk]
		>=x11-libs/gtk+-3.10:3
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=net-libs/webkit-gtk-2.11.91:4
		${gdata_depend}
	)
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.8:=
		${gdata_depend} )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

# Some tests fail due to missings locales.
# Also, dbus tests are flacky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare

	# Make CMakeLists versioned vala enabled
	sed -e "s;\(find_program(VALAC\) valac);\1 ${VALAC});" \
	    -e "s;\(find_program(VAPIGEN\) vapigen);\1 ${VAPIGEN});" \
		-i "${S}"/CMakeLists.txt || die
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	local google_auth_enable
	if use google || use gnome-online-accounts; then
		google_auth_enable="ON"
	else
		google_auth_enable="OFF"
	fi

	# phonenumber does not exist in tree
	local mycmakeargs=(
		-DENABLE_GTK_DOC=$(usex api-doc-extras)
		-DWITH_PRIVATE_DOCS=$(usex api-doc-extras)
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DWITH_KRB5=$(usex kerberos)
		-DWITH_KRB5_INCLUDES=$(usex kerberos "${EPREFIX}"/usr "")
		-DWITH_KRB5_LIBS=$(usex kerberos "${EPREFIX}"/usr/$(get_libdir) "")
		-DWITH_OPENLDAP=$(usex ldap)
		-DWITH_PHONENUMBER=OFF
		-DENABLE_SMIME=ON
		-DENABLE_GTK=$(usex gtk)
		-DENABLE_GOOGLE_AUTH=${google_auth_enable}
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DENABLE_UOA=OFF
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr OFF)
		# ENABLE_BACKTRACES requires libdwarf ?
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_GOOGLE=$(usex google)
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	virtx cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym /usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}
