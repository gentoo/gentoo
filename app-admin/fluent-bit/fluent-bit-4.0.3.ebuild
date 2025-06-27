# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast Log processor and Forwarder"
HOMEPAGE="https://fluentbit.io/"
SRC_URI="https://github.com/fluent/fluent-bit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="geoip kafka lua"

DEPEND="
	acct-group/fluentd
	acct-user/fluentd
	app-arch/zstd:=
	dev-libs/libyaml
	dev-libs/openssl:=
	net-dns/c-ares:=
	net-libs/nghttp2
	sys-libs/zlib
	kafka? ( dev-libs/librdkafka )
	lua? ( dev-lang/luajit )
	geoip? ( dev-libs/libmaxminddb )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${FILESDIR}/fluent-bit-4.0.3-wasm-cmake-version.patch"
	"${FILESDIR}/fluent-bit-4.0.3-external-libmaxminddb.patch"
	"${FILESDIR}/fluent-bit-4.0.3-wasm-noexec-stack.patch"
)

src_configure() {
	local mycmakeargs=(
		-DFLB_PREFER_SYSTEM_LIBS=Yes
		-DFLB_LUAJIT=$(usex lua Yes No)
		-DFLB_AVRO_ENCODER=No
		-DFLB_FILTER_GEOIP2=$(usex geoip Yes No)

		-DFLB_RELEASE=On
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/initd-1" "${PN}"
}
