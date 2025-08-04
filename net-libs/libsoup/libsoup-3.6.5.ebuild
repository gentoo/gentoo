# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib vala xdg

DESCRIPTION="HTTP client/server library for GNOME"
HOMEPAGE="https://libsoup.gnome.org"

LICENSE="LGPL-2.1+"
SLOT="3.0"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+brotli gssapi gtk-doc +introspection samba ssl sysprof test +vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.70.0:2[${MULTILIB_USEDEP}]
	net-libs/nghttp2:=[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	brotli? ( >=app-arch/brotli-1.0.6-r1:=[${MULTILIB_USEDEP}] )
	>=net-libs/libpsl-0.20[${MULTILIB_USEDEP}]
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
	sys-libs/zlib
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	samba? ( net-fs/samba )
"
RDEPEND="${DEPEND}
	>=net-libs/glib-networking-2.70_alpha[ssl?,${MULTILIB_USEDEP}]
"
BDEPEND="
	dev-libs/glib
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.1.2
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	test? ( >=net-libs/gnutls-3.6.0[pkcs11] )
"
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

PATCHES=(
	# Disable apache tests until they are usable on Gentoo, bug #326957
	"${FILESDIR}"/disable-apache-tests.patch
)

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
	# https://gitlab.gnome.org/GNOME/libsoup/issues/159 - could work with libnss-myhostname
	sed -e '/hsts/d' -i tests/meson.build || die
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	# But unnecessary while apache tests are disabled
	#addpredict /usr/share/snmp/mibs/.index

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		# Avoid auto-magic, built-in feature of meson
		-Dauto_features=enabled

		$(meson_feature gssapi)
		$(meson_feature samba ntlm)
		$(meson_feature brotli)
		-Dntlm_auth="${EPREFIX}/usr/bin/ntlm_auth"
		-Dtls_check=false # disables check, we still rdep on glib-networking
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala vapi)
		$(meson_native_use_feature gtk-doc docs)
		-Ddoc_tests=false
		$(meson_use test tests)
		-Dautobahn=disabled
		-Dinstalled_tests=false
		$(meson_feature sysprof)
		$(meson_feature test pkcs11_tests)
	)
	meson_src_configure
}

multilib_src_install_all() {
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/libsoup-3.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
