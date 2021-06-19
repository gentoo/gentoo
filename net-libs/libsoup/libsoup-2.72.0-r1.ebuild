# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson-multilib vala xdg

DESCRIPTION="HTTP client/server library for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2.1+"
SLOT="2.4"

# TODO: Default enable brotli at some point? But in 2.70.0 not advertised to servers yet - https://gitlab.gnome.org/GNOME/libsoup/issues/146
IUSE="brotli gssapi gtk-doc +introspection samba ssl sysprof test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	>=dev-libs/glib-2.58:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	brotli? ( >=app-arch/brotli-1.0.6-r1:=[${MULTILIB_USEDEP}] )
	>=net-libs/libpsl-0.20[${MULTILIB_USEDEP}]
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
	sys-libs/zlib
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	samba? ( net-fs/samba )
"
RDEPEND="${DEPEND}
	>=net-libs/glib-networking-2.38.2[ssl?,${MULTILIB_USEDEP}]
"
BDEPEND="
	dev-libs/glib
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.20
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
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
	use vala && vala_src_prepare
	xdg_src_prepare
	# https://gitlab.gnome.org/GNOME/libsoup/issues/159 - could work with libnss-myhostname
	sed -e '/hsts/d' -i tests/meson.build || die
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	# But necessary while apache tests are disabled
	#addpredict /usr/share/snmp/mibs/.index

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature gssapi)
		-Dkrb5_config="${CHOST}-krb5-config"
		$(meson_feature samba ntlm)
		$(meson_feature brotli)
		-Dntlm_auth="${EPREFIX}/usr/bin/ntlm_auth"
		-Dtls_check=false # disables check, we still rdep on glib-networking
		-Dgnome=false
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala vapi)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_use test tests)
		-Dinstalled_tests=false
		$(meson_feature sysprof)
	)
	meson_src_configure
}
