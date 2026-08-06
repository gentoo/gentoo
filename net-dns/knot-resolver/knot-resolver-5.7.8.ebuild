# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua-single meson optfeature tmpfiles verify-sig

DESCRIPTION="Scaleable caching DNS resolver"
HOMEPAGE="https://www.knot-resolver.cz https://gitlab.nic.cz/knot/knot-resolver"
SRC_URI="
	https://knot-resolver.nic.cz/release/${P}.tar.xz
	verify-sig? ( https://knot-resolver.nic.cz/release/${P}.tar.xz.asc )
"

LICENSE="Apache-2.0 BSD CC0-1.0 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="caps dnstap kresc nghttp2 selinux systemd test xdp"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	acct-group/knot-resolver
	acct-user/knot-resolver
	dev-db/lmdb:=
	dev-libs/libuv:=
	net-dns/knot:=[xdp?]
	net-libs/gnutls:=
	caps? ( sys-libs/libcap-ng )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	kresc? ( dev-libs/libedit )
	nghttp2? ( net-libs/nghttp2:= )
	selinux? ( sec-policy/selinux-knot )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	virtual/pkgconfig
	dnstap? (
		dev-libs/protobuf[protoc(+)]
		dev-libs/protobuf-c
	)
	verify-sig? ( >=sec-keys/openpgp-keys-knot-resolver-20260304 )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.3-docdir.patch
	"${FILESDIR}"/${PN}-5.5.3-nghttp-openssl.patch
	"${FILESDIR}"/${PN}-5.7.4-libsystemd.patch

	# backport from 6.X
	"${FILESDIR}"/${PN}-5.7.8-fix_luajit_include.patch
)

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var # double lib
		# avoid automagic, see #870019
		-Dauto_features=disabled
		# post-install tests
		-Dconfig_tests=disabled
		# DISTUTILS_SINGLE_IMPL can't use python_gen_any_dep
		# disable doc (html) to avoid relying on sphinx for PYTHON_COMPAT
		-Ddoc=disabled
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		# disable jemalloc, see #969223
		-Dmalloc=disabled
		# disable debug for the deprecated module 'http'
		-Dopenssl=disabled
		# always install tmpfiles
		-Dsystemd_files=enabled
		$(meson_feature caps capng)
		$(meson_feature dnstap)
		$(meson_feature kresc client)
		$(meson_feature nghttp2)
		$(meson_feature systemd)
		$(meson_feature test unit_tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	fowners -R ${PN}: /etc/${PN}
	newinitd "${FILESDIR}"/kresd.initd-r2 kresd
	newconfd "${FILESDIR}"/kresd.confd-r1 kresd
	newinitd "${FILESDIR}"/kres-cache-gc.initd kres-cache-gc
}

pkg_postinst() {
	tmpfiles_process knot-resolver.conf
	optfeature_header "This package is recommended with Knot Resolver:"
	optfeature "asynchronous execution, especially with policy module" dev-lua/cqueues
	optfeature_header "Other packages may also be useful:"
	optfeature "legacy doh and webmgmt (metrics, tracking)" dev-lua/lua-http
	optfeature "server map with geoIP database (webmgmt)" dev-lua/lua-mmdb
}
