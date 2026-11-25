# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 eapi9-ver lua-single meson optfeature tmpfiles verify-sig

DESCRIPTION="Scaleable caching DNS resolver"
HOMEPAGE="https://www.knot-resolver.cz https://gitlab.nic.cz/knot/knot-resolver"
SRC_URI="
	https://knot-resolver.nic.cz/release/${P}.tar.xz
	verify-sig? ( https://knot-resolver.nic.cz/release/${P}.tar.xz.asc )
"

LICENSE="Apache-2.0 BSD CC0-1.0 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="caps dnstap legacy nghttp2 quic systemd test xdp"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	!legacy? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	${LUA_DEPS}
	acct-group/knot-resolver
	acct-user/knot-resolver
	dev-db/lmdb:=
	>=dev-libs/libuv-1.27:=
	>=net-dns/knot-3.3:=[xdp?]
	>=net-libs/gnutls-3.4:=
	caps? ( sys-libs/libcap-ng )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	!legacy? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-admin/supervisor[${PYTHON_USEDEP}]
			dev-python/aiohttp[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
		')
	)
	nghttp2? ( net-libs/nghttp2:= )
	quic? ( >=net-libs/ngtcp2-1.11.0[gnutls] )
	systemd? ( >=sys-apps/systemd-235:= )
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
	!legacy? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			test? (
				>=dev-python/pyparsing-3.1.4[${PYTHON_USEDEP}]
				>=dev-python/pytest-asyncio-0.23.8[${PYTHON_USEDEP}]
			)
		')
	)
	verify-sig? ( >=sec-keys/openpgp-keys-knot-resolver-20260304 )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.3-docdir.patch
	"${FILESDIR}"/${PN}-5.5.3-nghttp-openssl.patch
	"${FILESDIR}"/${PN}-6.0.9-config-example.patch
	"${FILESDIR}"/${PN}-6.5.0-libsystemd.patch

	# upstream
	"${FILESDIR}"/${P}-execinfo.patch
)

pkg_setup() {
	lua-single_pkg_setup
	use legacy || python-single-r1_pkg_setup
}

src_prepare() {
	default
	use legacy || distutils-r1_src_prepare
}

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
		$(meson_feature caps capng)
		$(meson_feature dnstap)
		# legacy sample config
		$(meson_feature legacy install_kresd_conf)
		# install systemd unit
		$(meson_feature !legacy systemd_files)
		$(meson_feature nghttp2)
		-Dquic=$(usex quic external disabled)
		$(meson_feature systemd)
		$(meson_feature test unit_tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	use legacy || distutils-r1_src_compile
}

src_test() {
	meson_src_test
	use legacy || distutils-r1_src_test
}

python_test() {
	epytest tests/python/knot_resolver
}

src_install() {
	meson_src_install
	if use legacy; then
		newinitd "${FILESDIR}"/kresd.initd-r2 kresd
		newconfd "${FILESDIR}"/kresd.confd-r1 kresd
		newinitd "${FILESDIR}"/kres-cache-gc.initd kres-cache-gc
		# kresd.conf is installed instead
		rm "${ED}"/etc/knot-resolver/config.yaml || die
	else
		distutils-r1_src_install
		newinitd "${FILESDIR}"/knot-resolver.initd-r2 knot-resolver
		newconfd "${FILESDIR}"/knot-resolver.confd-r2 knot-resolver
		# already handled by acct-{group,user}/knot-resolver
		rm "${ED}"/usr/lib/sysusers.d/knot-resolver.conf || die
	fi

	fowners -R ${PN}: /etc/${PN}

	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process knot-resolver.conf

	if ver_replacing -lt 6.0.0; then
		ewarn "Knot-Resolver-6.X brings major changes, please read the guide for upgrading:"
		ewarn "https://www.knot-resolver.cz/documentation/v${PV}/upgrading-to-6.html"
		elog "Start Knot Resolver with:"
		use systemd && elog "    systemctl start knot-resolver.service"
		use !systemd && elog "    rc-service knot-resolver start"
		elog "Configuration file: /etc/knot-resolver/config.yaml"
	fi

	optfeature_header "This package is recommended with Knot Resolver:"
	optfeature "asynchronous execution, especially with policy module" dev-lua/cqueues

	if ! use legacy; then
		optfeature_header "Other packages may also be useful:"
		optfeature "Prometheus metrics" dev-python/prometheus-client
		optfeature "auto-reload TLS certificate files and RPZ files" dev-python/watchdog
	fi
}
