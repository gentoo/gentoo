# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ipset/ipset-6.16.ebuild,v 1.3 2014/08/10 20:55:50 slyfox Exp $

EAPI="5"
inherit autotools linux-info linux-mod

DESCRIPTION="IPset tool for iptables, successor to ippool"
HOMEPAGE="http://ipset.netfilter.org/"
SRC_URI="http://ipset.netfilter.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="modules"

RDEPEND=">=net-firewall/iptables-1.4.7
	net-libs/libmnl"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog INSTALL README UPGRADE )

# configurable from outside, e.g. /etc/make.conf
IP_NF_SET_MAX=${IP_NF_SET_MAX:-256}

BUILD_TARGETS="modules"
MODULE_NAMES_ARG="kernel/net/netfilter/ipset/:${S}/kernel/net/netfilter/ipset"
MODULE_NAMES="xt_set(kernel/net/netfilter/ipset/:${S}/kernel/net/netfilter/)"
for i in ip_set{,_bitmap_{ip{,mac},port},_hash_{ip{,port{,ip,net}},net,net{port,iface}},_list_set}; do
	MODULE_NAMES+=" ${i}(${MODULE_NAMES_ARG})"
done

check_header_patch() {
	if ! $(grep -q NFNL_SUBSYS_IPSET "${KV_DIR}/include/linux/netfilter/nfnetlink.h"); then
		eerror "Sorry, but you have to patch kernel sources with the following patch:"
		eerror " # cd ${KV_DIR}"
		eerror " # patch -i ${S}/netlink.patch -p1"
		eerror "You should recompile and run new kernel to avoid runtime errors."
		die "Unpatched kernel"
	fi
}

pkg_setup() {
	get_version
	CONFIG_CHECK="NETFILTER"
	ERROR_NETFILTER="ipset requires NETFILTER support in your kernel."

	build_modules=0
	if use modules; then
		kernel_is -lt 2 6 35 && die "${PN} requires kernel greater then 2.6.35."
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
	[[ ${build_modules} -eq 1 ]] && linux-mod_pkg_setup
}

src_prepare() {
	[[ ${build_modules} -eq 1 ]] && check_header_patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with modules kmod) \
		--disable-static \
		--with-maxsets=${IP_NF_SET_MAX} \
		--libdir="${EPREFIX}/$(get_libdir)" \
		--with-ksource="${KV_DIR}" \
		--with-kbuild="${KV_OUT_DIR}"
}

src_compile() {
	einfo "Building userspace"
	emake

	if [[ ${build_modules} -eq 1 ]]; then
		einfo "Building kernel modules"
		set_arch_to_kernel
		emake modules
	fi
}

src_install() {
	einfo "Installing userspace"
	default
	prune_libtool_files

	newinitd "${FILESDIR}"/ipset.initd-r2 ${PN}
	newconfd "${FILESDIR}"/ipset.confd ${PN}
	keepdir /var/lib/ipset

	if [[ ${build_modules} -eq 1 ]]; then
		einfo "Installing kernel modules"
		linux-mod_src_install
	fi
}
