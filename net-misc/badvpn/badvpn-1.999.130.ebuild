# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils cmake-utils user toolchain-funcs systemd

MY_P=${PN}-${PV/_rc/rc}
DESCRIPTION="Peer-to-peer VPN, NCD scripting language, tun2socks proxifier"
HOMEPAGE="https://github.com/ambrop72/badvpn https://code.google.com/p/badvpn/"
SRC_URI="https://github.com/ambrop72/badvpn/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
TARGETS="+client +ncd +server +tun2socks +udpgw"
IUSE="${TARGETS} debug"
# tests are only ncd related
RESTRICT="!ncd? ( test )"

COMMON_DEPEND="
	client? (
		dev-libs/nspr
		dev-libs/nss
		dev-libs/openssl:0
	)
	server? (
		dev-libs/nspr
		dev-libs/nss
		dev-libs/openssl:0
	)"
RDEPEND="${COMMON_DEPEND}
	ncd? (
		sys-apps/iproute2
		>=virtual/udev-171
	)"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
# we need at least one target
REQUIRED_USE="|| ( ${TARGETS//+/} )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser ${PN}
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_NOTHING_BY_DEFAULT=1
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_build ncd NCD)
		$(cmake-utils_use_build tun2socks TUN2SOCKS)
		$(cmake-utils_use_build udpgw UDPGW)
	)

	cmake-utils_src_configure
}

src_test() {
	# OOHMSA: do this on portage level?
	tc-is-cross-compiler && die "these tests do not work when cross compiling!"

	einfo "Running NCD tests"
	cd "${S}"/ncd/tests || die
	bash ./run_tests "${CMAKE_BUILD_DIR}/ncd/badvpn-ncd" \
		|| die "one or more tests failed"
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog

	if use server; then
		newinitd "${FILESDIR}"/${PN}-server.init ${PN}-server
		newconfd "${FILESDIR}"/${PN}-server.conf ${PN}-server
	fi

	if use ncd; then
		newinitd "${FILESDIR}"/${PN}-1.999.127-ncd.init ${PN}-ncd
		newconfd "${FILESDIR}"/${PN}-ncd.conf ${PN}-ncd
		systemd_dounit "${FILESDIR}"/badvpn-ncd.service
	fi
}
