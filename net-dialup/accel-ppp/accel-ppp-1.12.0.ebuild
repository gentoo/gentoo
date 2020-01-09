# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic linux-info linux-mod

DESCRIPTION="High performance PPTP, PPPoE and L2TP server"
HOMEPAGE="https://sourceforge.net/projects/accel-ppp/"
SRC_URI="https://download.sourceforge.net/accel-ppp/${P}.tar.bz2 -> ${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc ipoe lua postgres radius shaper snmp valgrind"

RDEPEND="lua? ( dev-lang/lua:0 )
	postgres? ( dev-db/postgresql:* )
	snmp? ( net-analyzer/net-snmp )
	dev-libs/libpcre
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"
PDEPEND="net-dialup/ppp-scripts"

DOCS=( README )

CONFIG_CHECK="~L2TP ~PPPOE ~PPTP"

REQUIRED_USE="valgrind? ( debug )"

PATCHES=(
	"${FILESDIR}/${PN}-1.11.1-socklen.patch"
	"${FILESDIR}/${PV}-kernel-5.2.patch"
)

pkg_setup() {
	if use ipoe; then
		linux-mod_pkg_setup
		set_arch_to_kernel
	else
		linux-info_pkg_setup
	fi
}

src_prepare() {
	sed -i  -e "/mkdir/d" \
		-e "s: RENAME accel-ppp.conf.dist::" accel-pppd/CMakeLists.txt || die 'sed on accel-pppd/CMakeLists.txt failed'

	# Do not install kernel modules like that - breaks sandbox!
	sed -i -e '/modules_install/d' \
		drivers/ipoe/CMakeLists.txt \
		drivers/vlan_mon/CMakeLists.txt || die

	# Fix version
	sed -i -e "s/1.11/${PV}/" drivers/ipoe/ipoe.c || die
	sed -i -e "s/1.11/${PV}/" drivers/vlan_mon/vlan_mon.c || die

	# Bug #549918
	append-ldflags -Wl,-z,lazy

	cmake-utils_src_prepare
}

src_configure() {
	local libdir="$(get_libdir)"
	# There must be also dev-libs/tomcrypt (TOMCRYPT) as crypto alternative to OpenSSL
	local mycmakeargs=(
		-DLIB_SUFFIX="${libdir#lib}"
		-DBUILD_IPOE_DRIVER="$(usex ipoe)"
		-DBUILD_PPTP_DRIVER=no
		-DBUILD_VLAN_MON_DRIVER="$(usex ipoe)"
		-DCRYPTO=OPENSSL
		-DLOG_PGSQL="$(usex postgres)"
		-DLUA="$(usex lua)"
		-DMEMDEBUG="$(usex debug)"
		-DNETSNMP="$(usex snmp)"
		-DRADIUS="$(usex radius)"
		-DSHAPER="$(usex shaper)"
		$(use debug && echo "-DVALGRIND=$(usex valgrind)")
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use ipoe; then
		local MODULE_NAMES="ipoe(accel-ppp:${BUILD_DIR}/drivers/ipoe/driver) vlan_mon(accel-ppp:${BUILD_DIR}/drivers/vlan_mon/driver)"
		linux-mod_src_install
	fi

	cmake-utils_src_install

	use doc && dodoc -r rfc

	if use snmp; then
		insinto /usr/share/snmp/mibs
		doins accel-pppd/extra/net-snmp/ACCEL-PPP-MIB.txt
	fi

	newinitd "${FILESDIR}"/${PN}.initd ${PN}d
	newconfd "${FILESDIR}"/${PN}.confd ${PN}d

	dodir /var/log/accel-ppp
}
