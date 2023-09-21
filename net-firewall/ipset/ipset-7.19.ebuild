# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE=modules
inherit bash-completion-r1 linux-mod-r1 systemd

DESCRIPTION="IPset tool for iptables, successor to ippool"
HOMEPAGE="https://ipset.netfilter.org/ https://git.netfilter.org/ipset/"
SRC_URI="https://ipset.netfilter.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=net-firewall/iptables-1.4.7
	net-libs/libmnl:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog INSTALL README UPGRADE )

# Configurable from outside, e.g. /etc/portage/make.conf
IP_NF_SET_MAX=${IP_NF_SET_MAX:-256}

pkg_setup() {
	get_version

	CONFIG_CHECK="NETFILTER NETFILTER_NETLINK !PAX_CONSTIFY_PLUGIN"
	ERROR_NETFILTER="ipset requires NETFILTER support in your kernel."
	ERROR_NETFILTER_NETLINK="ipset requires NETFILTER_NETLINK support in your kernel."
        ERROR_PAX_CONSTIFY_PLUGIN="ipset contains constified variables (bug #614896)"

	# It does still build without NET_NS, but it may be needed in future.
	#CONFIG_CHECK="${CONFIG_CHECK} NET_NS"
	#ERROR_NET_NS="ipset requires NET_NS (network namespace) support in your kernel."

	build_modules=0
	if use modules; then
		if linux_config_src_exists && linux_chkconfig_builtin "MODULES"; then
			# bug #274577
			if linux_chkconfig_present "IP_NF_SET" || linux_chkconfig_present "IP_SET"; then
				eerror "There is IP{,_NF}_SET or NETFILTER_XT_SET support in your kernel."
				eerror "Please either build ipset with modules USE flag disabled"
				eerror "or rebuild kernel without IP_SET support and make sure"
				eerror "there is NO kernel ip_set* modules in /lib/modules/<your_kernel>/... ."
				die "USE=modules and in-kernel ipset support detected."
			else
				einfo "Modular kernel detected. Will build kernel modules..."
				build_modules=1
			fi
		else
			eerror "Monolithic kernel detected, but USE=modules. Either build"
			eerror "modular kernel (without IP_SET) or disable USE=modules"
			die "Monolithic kernel detected, will not build kernel modules"
		fi
	fi

	[[ ${build_modules} -eq 1 ]] && linux-mod-r1_pkg_setup
}

src_configure() {
	export bashcompdir="$(get_bashcompdir)"

	local myeconfargs=(
		--enable-bashcompl
		$(use_with modules kmod)
		--with-maxsets=${IP_NF_SET_MAX}
		--with-ksource="${KV_DIR}"
		--with-kbuild="${KV_OUT_DIR}"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake

	if [[ ${build_modules} -eq 1 ]]; then
		MODULES_MAKEARGS+=(
			KBUILDDIR="${KV_OUT_DIR}"
			INSTALL_MOD_DIR="extra" # Makefile wants 'extra' for warning
		)

		emake "${MODULES_MAKEARGS[@]}" modules
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	newinitd "${FILESDIR}"/ipset.initd-r5 ${PN}
	newconfd "${FILESDIR}"/ipset.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/ipset.systemd-r1 ${PN}.service
	keepdir /var/lib/ipset

	if [[ ${build_modules} -eq 1 ]]; then
		emake "${MODULES_MAKEARGS[@]}" INSTALL_MOD_PATH="${ED}" modules_install
		modules_post_process
	fi
}
