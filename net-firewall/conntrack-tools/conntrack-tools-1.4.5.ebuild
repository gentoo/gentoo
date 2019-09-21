# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools linux-info

DESCRIPTION="Connection tracking userspace tools"
HOMEPAGE="http://conntrack-tools.netfilter.org"
SRC_URI="http://www.netfilter.org/projects/conntrack-tools/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm64 hppa x86"
IUSE="doc +cthelper +cttimeout +libtirpc"

RDEPEND="
	>=net-libs/libmnl-1.0.3
	>=net-libs/libnetfilter_conntrack-1.0.7
	cthelper? (
		>=net-libs/libnetfilter_cthelper-1.0.0
	)
	cttimeout? (
		>=net-libs/libnetfilter_cttimeout-1.0.0
	)
	>=net-libs/libnetfilter_queue-1.0.2
	>=net-libs/libnfnetlink-1.0.1
	!libtirpc? ( sys-libs/glibc[rpc(-)] )
	libtirpc? ( net-libs/libtirpc )
"
DEPEND="
	${RDEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	)
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-rpc.patch
)

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 18 ; then
		die "${PN} requires at least 2.6.18 kernel version"
	fi

	#netfilter core team has changed some option names with kernel 2.6.20
	if kernel_is lt 2 6 20 ; then
		CONFIG_CHECK="~IP_NF_CONNTRACK_NETLINK"
	else
		CONFIG_CHECK="~NF_CT_NETLINK"
	fi
	CONFIG_CHECK="${CONFIG_CHECK} ~NF_CONNTRACK
		~NETFILTER_NETLINK ~NF_CONNTRACK_EVENTS"

	check_extra_config

	linux_config_exists || \
		linux_chkconfig_present "NF_CONNTRACK_IPV4" || \
		linux_chkconfig_present "NF_CONNTRACK_IPV6" || \
		ewarn "CONFIG_NF_CONNTRACK_IPV4 or CONFIG_NF_CONNTRACK_IPV6 " \
			"are not set when one at least should be."
}

src_prepare() {
	default

	# bug #474858
	sed -i -e 's:/var/lock:/run/lock:' doc/stats/conntrackd.conf || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cthelper) \
		$(use_enable cttimeout) \
		$(use_with libtirpc)
}

src_compile() {
	default
	use doc && emake -C doc/manual
}

src_install() {
	default

	newinitd "${FILESDIR}/conntrackd.initd-r3" conntrackd
	newconfd "${FILESDIR}/conntrackd.confd-r2" conntrackd

	insinto /etc/conntrackd
	doins doc/stats/conntrackd.conf

	dodoc -r doc/sync doc/stats AUTHORS TODO
	use doc && dodoc doc/manual/${PN}.html
}
