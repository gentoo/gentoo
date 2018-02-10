# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"
inherit linux-info linux-mod toolchain-funcs

DESCRIPTION="Netflow iptables module"
HOMEPAGE="https://sourceforge.net/projects/ipt-netflow"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug natevents snmp"

RDEPEND="
	net-firewall/iptables
	snmp? ( net-analyzer/net-snmp )
"
DEPEND="${RDEPEND}
	virtual/linux-sources
	virtual/pkgconfig
"

# set S before MODULE_NAMES
S="${WORKDIR}/${MY_P}"
PATCHES=(
	# bug #455984
	"${FILESDIR}/${PN}-2.0-configure.patch"
	# Compatibility with kernel 4.6
	"${FILESDIR}/${P}-linux-4.6.patch"
	# Compatibility with kernel 4.10, bug #617484
	"${FILESDIR}/${P}-linux-4.10.patch"
	# Compatibility with kernel 4.13, bug #630446
	"${FILESDIR}/${P}-linux-4.13.patch"
	# Compatibility with kernel 4.15, bug #646798
	"${FILESDIR}/${P}-linux-4.15.patch"
)

pkg_setup() {
	BUILD_TARGETS="all"
	MODULE_NAMES="ipt_NETFLOW(ipt_netflow:${S})"
	IPT_LIB="/usr/$(get_libdir)/xtables"
	local CONFIG_CHECK="~IP_NF_IPTABLES"
	use debug && CONFIG_CHECK+=" ~DEBUG_FS"
	use natevents && CONFIG_CHECK+=" NF_CONNTRACK_EVENTS NF_NAT_NEEDED"
	linux-mod_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's:make -C:$(MAKE) -C:g' \
		-e 's:gcc -O2:$(CC) $(CFLAGS) $(LDFLAGS):' \
		-e 's:gcc:$(CC) $(CFLAGS) $(LDFLAGS):' \
		Makefile.in || die

	# Checking for directory is enough
	sed -i -e 's:-s /etc/snmp/snmpd.conf:-d /etc/snmp:' configure || die

	default
}

do_conf() {
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
