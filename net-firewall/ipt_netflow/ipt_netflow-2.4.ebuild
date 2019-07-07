# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info linux-mod toolchain-funcs

DESCRIPTION="Netflow iptables module"
HOMEPAGE="
	https://sourceforge.net/projects/ipt-netflow
	https://github.com/aabc/ipt-netflow
"
SRC_URI="https://github.com/aabc/ipt-netflow/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug natevents snmp"

RDEPEND="
	net-firewall/iptables:0=
	snmp? ( net-analyzer/net-snmp )
"
DEPEND="${RDEPEND}
	virtual/linux-sources
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-2.0-configure.patch" # bug #455984
	"${FILESDIR}/${PN}-2.3-flags.patch"
)

pkg_setup() {
	BUILD_TARGETS="all"
	MODULE_NAMES="ipt_NETFLOW(ipt_netflow:${S})"
	IPT_LIB="/usr/$(get_libdir)/xtables"
	local CONFIG_CHECK="~IP_NF_IPTABLES VLAN_8021Q"
	use debug && CONFIG_CHECK+=" ~DEBUG_FS"
	use natevents && CONFIG_CHECK+=" NF_CONNTRACK_EVENTS NF_NAT_NEEDED"
	linux-mod_pkg_setup
}

src_unpack() {
	default

	mv "${WORKDIR}"/${PN/_/-}-* "${WORKDIR}"/${P} || die
}

src_prepare() {
	default

	# Checking for directory is enough
	sed -i -e 's:-s /etc/snmp/snmpd.conf:-d /etc/snmp:' configure || die
}

do_conf() {
	tc-export CC
	echo ./configure $*
	./configure $* ${EXTRA_ECONF} || die 'configure failed'
}

src_configure() {
	local IPT_VERSION="$($(tc-getPKG_CONFIG) --modversion xtables)"
	# this configure script is not based on autotools
	# ipt-src need to be defined, see bug #455984
	do_conf \
		--disable-dkms \
		--enable-aggregation \
		--enable-direction \
		--enable-macaddress \
		--enable-vlan \
		--ipt-lib="${IPT_LIB}" \
		--ipt-src="/usr/" \
		--ipt-ver="${IPT_VERSION}" \
		--kdir="${KV_DIR}" \
		--kver="${KV_FULL}" \
		$(use debug && echo '--enable-debugfs') \
		$(use natevents && echo '--enable-natevents') \
		$(use snmp && echo '--enable-snmp-rules' || echo '--disable-snmp-agent')
}

src_compile() {
	emake ARCH="$(tc-arch-kernel)" CC="$(tc-getCC)" all
}

src_install() {
	linux-mod_src_install
	exeinto "${IPT_LIB}"
	doexe libipt_NETFLOW.so
	use snmp && emake DESTDIR="${D}" SNMPTGSO="/usr/$(get_libdir)/snmp/dlmod/snmp_NETFLOW.so" sinstall
	doheader ipt_NETFLOW.h
	dodoc README*
}
