# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit gnome2 multilib-minimal python-any-r1

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/LibSoup"

LICENSE="LGPL-2+"
SLOT="2.4"
IUSE="debug +introspection samba ssl test"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=net-libs/glib-networking-2.38.2[ssl?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( >=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}] )
"
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r8
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"

src_prepare() {
	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

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
		$(multilib_native_use_enable introspection) \
		$(use_with samba ntlm-auth '${EPREFIX}'/usr/bin/ntlm_auth)

	if multilib_is_native_abi; then
		# fix gtk-doc
		ln -s "${S}"/docs/reference/html docs/reference/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}
