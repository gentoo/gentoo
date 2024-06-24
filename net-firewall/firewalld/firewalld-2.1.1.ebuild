# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit bash-completion-r1 gnome2-utils linux-info optfeature
inherit plocale python-single-r1 systemd xdg-utils

DESCRIPTION="Firewall daemon with D-Bus interface providing a dynamic firewall"
HOMEPAGE="https://firewalld.org/"
SRC_URI="https://github.com/firewalld/firewalld/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
IUSE="gui +nftables +iptables selinux test"
# Tests are too unreliable in sandbox environment
RESTRICT="!test? ( test ) test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	|| ( >=sys-apps/openrc-0.11.5 sys-apps/systemd )
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		gui? (
			x11-libs/gtk+:3
			dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		)
		nftables? ( >=net-firewall/nftables-0.9.4[python,json] )
	')
	iptables? (
		net-firewall/iptables[ipv6(+)]
		net-firewall/ebtables
		net-firewall/ipset
		nftables? ( net-firewall/nftables[xtables(+)] )
	)
	selinux? ( sec-policy/selinux-firewalld )
"
DEPEND="
	${RDEPEND}
	dev-libs/glib:2
"
BDEPEND="
	app-text/docbook-xml-dtd
	>=dev-util/intltool-0.35
	sys-devel/gettext
"

# Testsuite's Makefile.am calls missing(!)
# ... but this seems to be consistent with the autoconf docs?
# Needs more investigation: https://www.gnu.org/software/autoconf/manual/autoconf-2.67/html_node/autom4te-Invocation.html
QA_AM_MAINTAINER_MODE=".*--run autom4te --language=autotest.*"

PLOCALES="ar as ast bg bn_IN ca cs da de el en_GB en_US es et eu fa fi fr gl gu hi hr hu ia id it ja ka kn ko lt ml mr nl or pa pl pt pt_BR ro ru si sk sl sq sr sr@latin sv ta te tr uk zh_CN zh_TW"

pkg_setup() {
	# See bug #830132 for the huge list
	# We can probably narrow it down a bit but it's rather fragile
	local CONFIG_CHECK="~NF_CONNTRACK ~NETFILTER_XT_MATCH_CONNTRACK
	~NETFILTER
	~NETFILTER_ADVANCED
	~NETFILTER_INGRESS
	~NF_NAT_MASQUERADE
	~NF_NAT_REDIRECT
	~NF_TABLES_INET
	~NF_TABLES_IPV4
	~NF_TABLES_IPV6
	~NF_CONNTRACK
	~NF_CONNTRACK_BROADCAST
	~NF_CONNTRACK_NETBIOS_NS
	~NF_CONNTRACK_TFTP
	~NF_CT_NETLINK
	~NF_CT_NETLINK_HELPER
	~NF_DEFRAG_IPV4
	~NF_DEFRAG_IPV6
	~NF_NAT
	~NF_NAT_TFTP
	~NF_REJECT_IPV4
	~NF_REJECT_IPV6
	~NF_SOCKET_IPV4
	~NF_SOCKET_IPV6
	~NF_TABLES
	~NF_TPROXY_IPV4
	~NF_TPROXY_IPV6
	~IP_NF_FILTER
	~IP_NF_IPTABLES
	~IP_NF_MANGLE
	~IP_NF_NAT
	~IP_NF_RAW
	~IP_NF_SECURITY
	~IP_NF_TARGET_MASQUERADE
	~IP_NF_TARGET_REJECT
	~IP6_NF_FILTER
	~IP6_NF_IPTABLES
	~IP6_NF_MANGLE
	~IP6_NF_NAT
	~IP6_NF_RAW
	~IP6_NF_SECURITY
	~IP6_NF_TARGET_MASQUERADE
	~IP6_NF_TARGET_REJECT
	~IP_SET
	~NETFILTER_CONNCOUNT
	~NETFILTER_NETLINK
	~NETFILTER_NETLINK_OSF
	~NETFILTER_NETLINK_QUEUE
	~NETFILTER_SYNPROXY
	~NETFILTER_XTABLES
	~NETFILTER_XT_CONNMARK
	~NETFILTER_XT_MATCH_CONNTRACK
	~NETFILTER_XT_MATCH_MULTIPORT
	~NETFILTER_XT_MATCH_STATE
	~NETFILTER_XT_NAT
	~NETFILTER_XT_TARGET_MASQUERADE
	~NFT_COMPAT
	~NFT_CT
	~NFT_FIB
	~NFT_FIB_INET
	~NFT_FIB_IPV4
	~NFT_FIB_IPV6
	~NFT_HASH
	~NFT_LIMIT
	~NFT_LOG
	~NFT_MASQ
	~NFT_NAT
	~NFT_QUEUE
	~NFT_QUOTA
	~NFT_REDIR
	~NFT_REJECT
	~NFT_REJECT_INET
	~NFT_REJECT_IPV4
	~NFT_REJECT_IPV6
	~NFT_SOCKET
	~NFT_SYNPROXY
	~NFT_TPROXY
	~NFT_TUNNEL
	~NFT_XFRM"

	# kernel >= 4.19 has unified a NF_CONNTRACK module, bug #692944
	if kernel_is -lt 4 19; then
		CONFIG_CHECK+=" ~NF_CONNTRACK_IPV4 ~NF_CONNTRACK_IPV6"
	fi

	# bug #831259
	if kernel_is -le 5 4 ; then
		CONFIG_CHECK+=" ~NF_TABLES_SET"
	fi

	# bug #853055
	if kernel_is -lt 5 18 ; then
		CONFIG_CHECK+=" ~NFT_COUNTER"
	fi

	# bug #926685
	if kernel_is -le 6 1 ; then
		CONFIG_CHECK+=" ~NFT_OBJREF"
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default

	plocale_find_changes "po" "" ".po" || die
	plocale_get_locales | sed -e 's/ /\n/g' > po/LINGUAS
}

src_configure() {
	python_setup

	local myeconfargs=(
		--enable-systemd
		$(use_with iptables iptables "${EPREFIX}/sbin/iptables")
		$(use_with iptables iptables_restore "${EPREFIX}/sbin/iptables-restore")
		$(use_with iptables ip6tables "${EPREFIX}/sbin/ip6tables")
		$(use_with iptables ip6tables_restore "${EPREFIX}/sbin/ip6tables-restore")
		$(use_with iptables ebtables "${EPREFIX}/sbin/ebtables")
		$(use_with iptables ebtables_restore "${EPREFIX}/sbin/ebtables-restore")
		$(use_with iptables ipset "${EPREFIX}/usr/sbin/ipset")
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
		--with-bashcompletiondir="$(get_bashcompdir)"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_optimize

	# Get rid of junk
	rm -rf "${D}/etc/sysconfig/" || die

	# For non-gui installs we need to remove GUI bits
	if ! use gui; then
		rm -rf "${D}/etc/xdg/autostart" || die
		rm -f "${D}/usr/bin/firewall-applet" || die
		rm -f "${D}/usr/bin/firewall-config" || die
		rm -rf "${D}/usr/share/applications" || die
		rm -rf "${D}/usr/share/icons" || die
	fi

	newinitd "${FILESDIR}"/firewalld.init firewalld

	# Our version drops the/an obsolete 'conflicts' line with old iptables services
	# bug #833506
	systemd_dounit "${FILESDIR}"/firewalld.service
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update

	# bug #833569
	optfeature "changing zones with NetworkManager" gnome-extra/nm-applet
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
