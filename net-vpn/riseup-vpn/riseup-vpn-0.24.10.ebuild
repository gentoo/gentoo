# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit desktop python-single-r1 go-module qmake-utils virtualx xdg

DESCRIPTION="Anonymous encrypted VPN client powered by Bitmask"
HOMEPAGE="https://riseup.net/en/vpn https://0xacab.org/leap/bitmask-vpn https://bitmask.net"
SRC_URI="
	https://0xacab.org/leap/bitmask-vpn/-/archive/${PV}/bitmask-vpn-${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~nowa/${P}-deps.tar.xz
"
S="${WORKDIR}/bitmask-vpn-${PV}"

# Generated with dev-go/golicense
LICENSE="GPL-3 BSD-2 CC0-1.0 MIT BSD"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="test"

PROPERTIES="test_network"
RESTRICT="test"
# The tests require internet access to connect to Riseup Networks

BDEPEND="
	virtual/pkgconfig
	dev-qt/qttools[linguist]
"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtsvg:6
	media-libs/libglvnd
"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	net-vpn/openvpn
	sys-auth/polkit
"

src_prepare() {
	default

	# do not pre-strip
	sed -i -e '/strip $RELEASE\/$TARGET/d' gui/build.sh || die

	# We need qmake and lrelease from  qt6 bin dir
	export PATH="${PATH}:$(qt6_get_bindir)" || die

	export PROVIDER=riseup
}

src_compile() {
	emake gen_providers_json
	emake build
}

src_test() {
	emake test
	virtx emake test_ui
}

src_install() {
	einstalldocs

	dobin build/qt/release/riseup-vpn

	python_scriptinto /usr/sbin
	python_doscript pkg/pickle/helpers/bitmask-root

	insinto /usr/share/polkit-1/actions
	newins pkg/pickle/helpers/se.leap.bitmask.policy se.leap.bitmask.riseupvpn.policy

	newicon -s scalable providers/riseup/assets/icon.svg riseup.svg
	make_desktop_entry ${PN} RiseupVPN riseup Network

	dodoc -r docs/*
}
