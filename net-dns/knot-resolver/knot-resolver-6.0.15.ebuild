# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 lua-single meson optfeature tmpfiles verify-sig

DESCRIPTION="A scaleable caching DNS resolver"
HOMEPAGE="https://www.knot-resolver.cz https://gitlab.nic.cz/knot/knot-resolver"
SRC_URI="
	https://knot-resolver.nic.cz/release/${P}.tar.xz
	verify-sig? ( https://knot-resolver.nic.cz/release/${P}.tar.xz.asc )
"

LICENSE="Apache-2.0 BSD CC0-1.0 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="caps dnstap jemalloc +manager nghttp2 selinux systemd test xdp"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	manager? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	${LUA_DEPS}
	acct-group/knot-resolver
	acct-user/knot-resolver
	dev-db/lmdb:=
	dev-libs/libuv:=
	>=net-dns/knot-3.3:=[xdp?]
	net-libs/gnutls:=
	caps? ( sys-libs/libcap-ng )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	jemalloc? ( dev-libs/jemalloc:= )
	manager? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-admin/supervisor[${PYTHON_USEDEP}]
			dev-python/aiohttp[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
		')
	)
	nghttp2? ( net-libs/nghttp2:= )
	selinux? ( sec-policy/selinux-knot )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-util/cmocka
		manager? (
			$(python_gen_cond_dep '
				dev-python/pyparsing[${PYTHON_USEDEP}]
				dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			')
		)
	)
"
BDEPEND="
	virtual/pkgconfig
	manager? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
	)
	verify-sig? ( >=sec-keys/openpgp-keys-knot-resolver-20240304 )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.gpg

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.3-docdir.patch
	"${FILESDIR}"/${PN}-5.5.3-nghttp-openssl.patch
	"${FILESDIR}"/${PN}-6.0.9-libsystemd.patch
	"${FILESDIR}"/${PN}-6.0.9-config-example.patch
	"${FILESDIR}"/${PN}-6.0.12-pytest_tomllib.patch
)

pkg_setup() {
	lua-single_pkg_setup
	use manager && python-single-r1_pkg_setup
}

src_prepare() {
	default
	use manager && distutils-r1_src_prepare
}

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var # double lib
		# https://bugs.gentoo.org/870019
		-Dauto_features=disabled
		# post-install tests
		-Dconfig_tests=disabled
		-Ddoc=disabled
		-Ddocdir="${EPREFIX}"/usr/share/doc/${PF}
		-Dinstall_kresd_conf=enabled
		-Dopenssl=disabled
		-Dmalloc=$(usex jemalloc jemalloc disabled)
		-Dsystemd_files=enabled
		$(meson_feature caps capng)
		$(meson_feature dnstap)
		$(meson_feature nghttp2)
		$(meson_feature systemd)
		$(meson_feature systemd systemd_legacy_units)
		$(meson_feature test unit_tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	use manager && distutils-r1_src_compile
}

src_test() {
	meson_src_test
	use manager && distutils-r1_src_test
}

python_test() {
	epytest tests/manager
}

src_install() {
	meson_src_install
	if use manager; then
		distutils-r1_src_install
		newinitd "${FILESDIR}"/knot-resolver.initd knot-resolver
		newconfd "${FILESDIR}"/knot-resolver.confd knot-resolver
	else
		rm "${ED}"/usr/lib/systemd/system/knot-resolver.service || die
	fi
	fowners -R ${PN}: /etc/${PN}
	newinitd "${FILESDIR}"/kresd.initd-r2 kresd
	newconfd "${FILESDIR}"/kresd.confd-r1 kresd
	newinitd "${FILESDIR}"/kres-cache-gc.initd kres-cache-gc
}

pkg_postinst() {
	tmpfiles_process knot-resolver.conf
	if use manager; then
		elog "You choose the new way, called the manager, to start Knot Resolver:"
		use systemd && elog "	systemctl start knot-resolver.service"
		use !systemd && elog "	/etc/init.d/knot-resolver start"
		elog "Configuration file: /etc/knot-resolver/config.yaml"
		elog ""
		elog "The older way, without the manager, is still available:"
	else
		elog "You choose the older way, without the manager, to start Knot Resolver:"
	fi
	use systemd && elog "	systemctl start kresd@N.service"
	use !systemd && elog "	/etc/init.d/kresd start"
	elog "Configuration file: /etc/knot-resolver/kresd.conf"
	elog "Optional garbage collector: /etc/init.d/kres-cache-gc"
	elog ""
	use !manager && elog "The new way is available with the useflag manager."
	elog ""

	optfeature_header "This package is recommended with Knot Resolver:"
	optfeature "asynchronous execution, especially with policy module" dev-lua/cqueues
	elog ""
	optfeature_header "Other packages may also be useful:"
	use manager && optfeature "Prometheus metrics (need manager)" dev-python/prometheus-client
	use manager && optfeature "auto-reload TLS certificate files and RPZ files (need manager)" dev-python/watchdog
	optfeature "legacy doh and webmgmt (metrics, tracking)" dev-lua/lua-http
	optfeature "server map with geoIP database (webmgmt)" dev-lua/lua-mmdb
}
