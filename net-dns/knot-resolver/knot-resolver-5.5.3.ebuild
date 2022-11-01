# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua-single meson tmpfiles verify-sig

DESCRIPTION="A scaleable caching DNS resolver"
HOMEPAGE="https://www.knot-resolver.cz https://gitlab.nic.cz/knot/knot-resolver"
SRC_URI="
	https://secure.nic.cz/files/${PN}/${P}.tar.xz
	verify-sig? ( https://secure.nic.cz/files/${PN}/${P}.tar.xz.asc )
"

LICENSE="Apache-2.0 BSD CC0-1.0 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="caps dnstap kresc nghttp2 systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	acct-group/knot-resolver
	acct-user/knot-resolver
	dev-db/lmdb:=
	dev-libs/libuv:=
	net-dns/knot:=
	net-libs/gnutls:=
	caps? ( sys-libs/libcap-ng )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	kresc? ( dev-libs/libedit )
	nghttp2? ( net-libs/nghttp2:= )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${RDEPEND}
	test? (
		  dev-util/cmocka
	)
"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-knot-resolver )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.3-docdir.patch
	"${FILESDIR}"/${PN}-5.5.3-nghttp-openssl.patch
)

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/${PN}.gpg

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.asc}
	fi

	unpack ${P}.tar.xz
}

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var # double lib
		# https://bugs.gentoo.org/870019
		-Dauto_features=disabled
		-Ddoc=disabled
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		-Dopenssl=disabled
		$(meson_feature caps capng)
		$(meson_feature dnstap)
		$(meson_feature kresc client)
		$(meson_feature nghttp2)
		$(meson_feature test unit_tests)
		$(meson_feature systemd systemd_files)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	fowners -R ${PN}: /etc/${PN}
}

pkg_postinst() {
	use systemd && tmpfiles_process knot-resolver.conf
}
