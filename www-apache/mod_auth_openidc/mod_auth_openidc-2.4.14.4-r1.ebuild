# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit depend.apache apache-module autotools

DESCRIPTION="OpenID Connect Relying Party implementation for Apache HTTP Server 2.x"
HOMEPAGE="https://github.com/OpenIDC/mod_auth_openidc"
SRC_URI="https://github.com/OpenIDC/mod_auth_openidc/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="brotli redis"

RDEPEND="
	app-misc/jq
	dev-libs/apr
	dev-libs/cjose
	dev-libs/jansson:=
	dev-libs/openssl:=
	dev-libs/libpcre
	net-misc/curl
	sys-libs/zlib:=
	brotli? ( app-arch/brotli:= )
	redis? ( dev-libs/hiredis:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="virtual/pkgconfig"

APACHE2_MOD_CONF="10_mod_auth_openidc"
APACHE2_MOD_DEFINE="AUTH_OPENIDC"
DOCFILES="README.md ChangeLog AUTHORS INSTALL auth_openidc.conf"

need_apache2_4

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	ECONF_ARGS=(
		$(use_with brotli)
		$(use_with redis hiredis)
	)
	econf "${ECONF_ARGS[@]}"
}

src_compile() {
	# Do not use apache-module_src_compile ; it does not compile properly
	default
}

src_install() {
	# Do not use apache-module_src_install ; it does not link properly
	default

	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}/${APACHE2_MOD_CONF}.conf"
	dodoc ${DOCFILES}
}

pkg_postinst() {
	apache-module_pkg_postinst
}
