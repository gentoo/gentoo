# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal python-any-r1 vala

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"

IUSE="debug gssapi +introspection samba ssl test +vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=net-libs/libpsl-0.20.0[${MULTILIB_USEDEP}]
	>=net-libs/glib-networking-2.38.2[ssl?,${MULTILIB_USEDEP}]
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.20
	>=dev-util/intltool-0.35
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( >=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}] )
	vala? ( $(vala_depend) )
"
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

src_prepare() {
	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	# FIXME: workaround upstream not respecting --without-apache-httpd
	sed -e '/check: start-httpd/d' \
		-i tests/Makefile.am tests/Makefile.in || die

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# Disable apache tests until they are usable on Gentoo, bug #326957
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-tls-check \
		--without-gnome \
		--without-apache-httpd \
		$(usex debug --enable-debug=yes ' ') \
		$(multilib_native_use_with gssapi) \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_enable vala) \
		$(use_with samba ntlm-auth '${EPREFIX}'/usr/bin/ntlm_auth)

	if multilib_is_native_abi; then
		# fix gtk-doc
		ln -s "${S}"/docs/reference/html docs/reference/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}
