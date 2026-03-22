# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )
MODULES_OPTIONAL_IUSE="ipoe"
inherit cmake flag-o-matic linux-mod-r1 lua-single

DESCRIPTION="High performance PPTP/L2TP/SSTP/PPPoE/IPoE server"
HOMEPAGE="https://accel-ppp.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/accel-ppp/accel-ppp.git"
else
	SRC_URI="https://github.com/accel-ppp/accel-ppp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc lua postgres radius shaper snmp valgrind"

RDEPEND="
	dev-libs/libpcre2
	dev-libs/openssl:0=
	lua? ( ${LUA_DEPS} )
	postgres? ( dev-db/postgresql:* )
	snmp? ( net-analyzer/net-snmp )
"
DEPEND="${RDEPEND}
	valgrind? ( dev-debug/valgrind )"
PDEPEND="net-dialup/ppp-scripts"

DOCS=( README )

CONFIG_CHECK="~L2TP ~PPPOE ~PPTP"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	valgrind? ( debug )"

pkg_setup() {
	linux-mod-r1_pkg_setup
	set_arch_to_kernel
	use lua && lua-single_pkg_setup
}

src_configure() {
	append-ldflags -Wl,-z,lazy # Bug #549918
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_LOCALSTATEDIR="${EPREFIX}/var"
		-DLIB_SUFFIX="${libdir#lib}"
		# modules handled by linux-mod
		-DBUILD_IPOE_DRIVER=no
		-DBUILD_PPTP_DRIVER=no
		-DBUILD_VLAN_MON_DRIVER=no
		-DCRYPTO_LIBRARY=OPENSSL
		-DLOG_PGSQL="$(usex postgres)"
		-DLUA="$(usex lua TRUE FALSE)"
		-DMEMDEBUG="$(usex debug)"
		-DNETSNMP="$(usex snmp)"
		-DRADIUS="$(usex radius)"
		-DSHAPER="$(usex shaper)"
		$(use debug && echo "-DVALGRIND=$(usex valgrind)")
	)
	cmake_src_configure
}

build_modules() {
	local mod modlist
	for mod in ipoe vlan_mon; do
		# see bug #971394
		ln -s "${BUILD_DIR}"/version.h drivers/${mod} || die
		local modlist+=( ${mod}=accel-ppp:drivers/${mod} )
	done
	MODULES_MAKEARGS+=(
		KDIR="${KV_OUT_DIR}"
	)
	linux-mod-r1_src_compile
}

src_compile() {
	use ipoe && build_modules
	cmake_src_compile

}

src_install() {
	linux-mod-r1_src_install
	cmake_src_install

	use doc && dodoc -r rfc

	if use snmp; then
		insinto /usr/share/snmp/mibs
		doins accel-pppd/extra/net-snmp/ACCEL-PPP-MIB.txt
	fi

	mv "${ED}"/etc/accel-ppp.conf{.dist,} || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}d
	newconfd "${FILESDIR}"/${PN}.confd ${PN}d

	keepdir /var/lib/accel-ppp
	keepdir /var/log/accel-ppp
}
