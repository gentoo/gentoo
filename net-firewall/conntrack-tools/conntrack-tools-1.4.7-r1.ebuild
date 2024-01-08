# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/netfilter.org.asc
inherit autotools linux-info systemd verify-sig

DESCRIPTION="Connection tracking userspace tools"
HOMEPAGE="https://conntrack-tools.netfilter.org"
SRC_URI="https://www.netfilter.org/projects/conntrack-tools/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/conntrack-tools/files/${P}.tar.bz2.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 ~riscv x86"
IUSE="doc +cthelper +cttimeout systemd"

RDEPEND="
	>=net-libs/libmnl-1.0.3
	>=net-libs/libnetfilter_conntrack-1.0.9
	>=net-libs/libnetfilter_queue-1.0.2
	>=net-libs/libnfnetlink-1.0.1
	net-libs/libtirpc
	cthelper? (
		>=net-libs/libnetfilter_cthelper-1.0.0
	)
	cttimeout? (
		>=net-libs/libnetfilter_cttimeout-1.0.0
	)
	systemd? (
		>=sys-apps/systemd-227
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	app-alternatives/lex
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	)
	verify-sig? ( sec-keys/openpgp-keys-netfilter )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-0001-Makefile.am-don-t-suppress-various-warnings.patch
	"${FILESDIR}"/${PN}-1.4.5-0002-Fix-Wstrict-prototypes.patch
	"${FILESDIR}"/${PN}-1.4.5-0003-Fix-Wimplicit-function-declaration.patch
)

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 18 ; then
		die "${PN} requires at least 2.6.18 kernel version"
	fi

	# netfilter core team has changed some option names with kernel 2.6.20
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

	# Drop once Clang 16 patches merged (implicit func decl, etc)
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cthelper) \
		$(use_enable cttimeout) \
		$(use_enable systemd)
}

src_compile() {
	default

	use doc && emake -C doc/manual
}

src_install() {
	default

	newinitd "${FILESDIR}"/conntrackd.initd-r3 conntrackd
	newconfd "${FILESDIR}"/conntrackd.confd-r2 conntrackd

	insinto /etc/conntrackd
	doins doc/stats/conntrackd.conf

	systemd_dounit "${FILESDIR}"/conntrackd.service

	dodoc -r doc/sync doc/stats AUTHORS TODO
	use doc && dodoc doc/manual/${PN}.html
}
