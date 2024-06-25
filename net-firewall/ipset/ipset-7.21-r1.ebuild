# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE=modules
inherit autotools bash-completion-r1 linux-mod-r1 systemd

DESCRIPTION="IPset tool for iptables, successor to ippool"
HOMEPAGE="https://ipset.netfilter.org/ https://git.netfilter.org/ipset/"
SRC_URI="https://ipset.netfilter.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"

RDEPEND="
	net-firewall/iptables
	net-libs/libmnl:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-bash-completion.patch" )

DOCS=( ChangeLog INSTALL README UPGRADE )

# configurable from outside, e.g. /etc/portage/make.conf
IP_NF_SET_MAX=${IP_NF_SET_MAX:-256}

src_prepare() {
	default
	eautoreconf
}

pkg_setup() {
	get_version
	CONFIG_CHECK="NETFILTER"
	ERROR_NETFILTER="ipset requires NETFILTER support in your kernel."
	CONFIG_CHECK+=" NETFILTER_NETLINK"
	ERROR_NETFILTER_NETLINK="ipset requires NETFILTER_NETLINK support in your kernel."
	# It does still build without NET_NS, but it may be needed in future.
	#CONFIG_CHECK="${CONFIG_CHECK} NET_NS"
	#ERROR_NET_NS="ipset requires NET_NS (network namespace) support in your kernel."
	CONFIG_CHECK+=" !PAX_CONSTIFY_PLUGIN"
	ERROR_PAX_CONSTIFY_PLUGIN="ipset contains constified variables (#614896)"

	build_modules=0
	if use modules; then
		if linux_config_src_exists && linux_chkconfig_builtin "MODULES" ; then
			if linux_chkconfig_present "IP_NF_SET" || \
				linux_chkconfig_present "IP_SET"; then #274577
				eerror "There is IP{,_NF}_SET or NETFILTER_XT_SET support in your kernel."
				eerror "Please either build ipset with modules USE flag disabled"
				eerror "or rebuild kernel without IP_SET support and make sure"
				eerror "there is NO kernel ip_set* modules in /lib/modules/<your_kernel>/... ."
				die "USE=modules and in-kernel ipset support detected."
			else
				einfo "Modular kernel detected. Gonna build kernel modules..."
				build_modules=1
			fi
		else
			eerror "Nonmodular kernel detected, but USE=modules. Either build"
			eerror "modular kernel (without IP_SET) or disable USE=modules"
			die "Nonmodular kernel detected, will not build kernel modules"
		fi
	fi

	[[ ${build_modules} -eq 1 ]] && linux-mod-r1_pkg_setup
}

src_configure() {
	export bashcompdir="$(get_bashcompdir)"

	econf \
		--enable-bashcompl \
		$(use_with modules kmod) \
		--with-maxsets=${IP_NF_SET_MAX} \
		--with-ksource="${KV_DIR}" \
		--with-kbuild="${KV_OUT_DIR}"
}

src_compile() {
	einfo "Building userspace"

	local modlist=( xt_set=kernel/net/netfilter/ipset/:"${S}":kernel/net/netfilter/:
					em_ipset=kernel/net/sched:"${S}":kernel/net/sched/:modules )

	for i in ip_set{,_bitmap_{ip{,mac},port},_hash_{ip{,mac,mark,port{,ip,net}},mac,net{,port{,net},iface,net}},_list_set}; do
		modlist+=( ${i}=kernel/net/netfilter/ipset/:"${S}":kernel/net/netfilter/ipset )
	done

	emake

	if [[ ${build_modules} -eq 1 ]]; then
		einfo "Building kernel modules"
		linux-mod-r1_src_compile
	fi
}

src_install() {
	einfo "Installing userspace"
	default

	find "${ED}" -name '*.la' -delete || die

	newinitd "${FILESDIR}"/ipset.initd-r7 ${PN}
	newconfd "${FILESDIR}"/ipset.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/ipset.systemd-r1 ${PN}.service
	keepdir /var/lib/ipset

	if [[ ${build_modules} -eq 1 ]]; then
		einfo "Installing kernel modules"
		linux-mod-r1_src_install
	fi
}
