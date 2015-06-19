# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/xtables-addons/xtables-addons-2.5.ebuild,v 1.1 2014/06/26 13:44:44 maksbotan Exp $

EAPI="5"

inherit eutils linux-info linux-mod multilib

DESCRIPTION="extensions not yet accepted in the main kernel/iptables (patch-o-matic(-ng) successor)"
HOMEPAGE="http://xtables-addons.sourceforge.net/"
SRC_URI="mirror://sourceforge/xtables-addons/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="modules"

MODULES="quota2 psd pknock lscan length2 ipv4options ipp2p iface gradm geoip fuzzy condition tarpit sysrq logmark ipmark echo dnetmap dhcpmac delude chaos account"

for mod in ${MODULES}; do
	IUSE="${IUSE} xtables_addons_${mod}"
done

DEPEND=">=net-firewall/iptables-1.4.5"

RDEPEND="${DEPEND}
	xtables_addons_geoip? (
		app-arch/unzip
		dev-perl/Text-CSV_XS
		virtual/perl-Getopt-Long
	)
"

DEPEND="${DEPEND}
	virtual/linux-sources"

SKIP_MODULES=""

# XA_kernel_check tee "2 6 32"
XA_check4internal_module() {
	local mod=${1}
	local version=${2}
	local kconfigname=${3}

	if use xtables_addons_${mod} && kernel_is -gt ${version}; then
		ewarn "${kconfigname} should be provided by the kernel. Skipping its build..."
		if ! linux_chkconfig_present ${kconfigname}; then
			ewarn "Please enable ${kconfigname} target in your kernel
			configuration or disable checksum module in ${PN}."
		fi
		# SKIP_MODULES in case we need to disable building of everything
		# like having this USE disabled
		SKIP_MODULES+=" ${mod}"
	fi
}

pkg_setup()	{
	if use modules; then
		get_version
		check_modules_supported
		CONFIG_CHECK="NF_CONNTRACK NF_CONNTRACK_MARK ~CONNECTOR"
		ERROR_CONNECTOR="Please, enable CONFIG_CONNECTOR if you wish to receive userspace notifications from pknock through netlink/connector"
		linux-mod_pkg_setup

		if ! linux_chkconfig_present IPV6; then
			SKIP_IPV6_MODULES="ip6table_rawpost"
			ewarn "No IPV6 support in kernel. Disabling: ${SKIP_IPV6_MODULES}"
		fi
		kernel_is -lt 3 7 && die "${P} requires kernel version >= 3.7, if you have older kernel please use 1.x version instead"
	fi
}

# Helper for maintainer: cheks if all possible MODULES are listed.
XA_qa_check() {
	local all_modules
	all_modules=$(sed -n '/^build_/{s/build_\(.*\)=.*/\L\1/;G;s/\n/ /;s/ $//;h}; ${x;p}' "${S}/mconfig")
	if [[ ${all_modules} != ${MODULES} ]]; then
		ewarn "QA: Modules in mconfig differ from \$MODULES in ebuild."
		ewarn "Please, update MODULES in ebuild."
		ewarn "'${all_modules}'"
	fi
}

# Is there any use flag set?
XA_has_something_to_build() {
	local mod
	for mod in ${MODULES}; do
		use xtables_addons_${mod} && return
	done

	eerror "All modules are disabled. What do you want me to build?"
	eerror "Please, set XTABLES_ADDONS to any combination of"
	eerror "${MODULES}"
	die "All modules are disabled."
}

# Parse Kbuid files and generates list of sources
XA_get_module_name() {
	[[ $# != 1 ]] && die "XA_get_sources_for_mod: needs exactly one argument."
	local mod objdir build_mod sources_list
	mod=${1}
	objdir=${S}/extensions
	# Take modules name from mconfig
	build_mod=$(sed -n "s/\(build_${mod}\)=.*/\1/Ip" "${S}/mconfig")
	# strip .o, = and everything before = and print
	sources_list=$(sed -n "/^obj-[$][{]${build_mod}[}]/\
		{s:obj-[^+]\+ [+]=[[:space:]]*::;s:[.]o::g;p}" \
				"${objdir}/Kbuild")

	if [[ -d ${S}/extensions/${sources_list} ]]; then
		objdir=${S}/extensions/${sources_list}
		sources_list=$(sed -n "/^obj-m/\
			{s:obj-[^+]\+ [+]=[[:space:]]*::;s:[.]o::g;p}" \
				"${objdir}/Kbuild")
	fi
	for mod_src in ${sources_list}; do
		has ${mod_src} ${SKIP_IPV6_MODULES} || \
			echo " ${mod_src}(xtables_addons:${S}/extensions:${objdir})"
	done
}

src_prepare() {
	XA_qa_check
	XA_has_something_to_build

	local mod module_name
	if use modules; then
		MODULE_NAMES="compat_xtables(xtables_addons:${S}/extensions:)"
	fi
	for mod in ${MODULES}; do
		if ! has ${mod} ${SKIP_MODULES} && use xtables_addons_${mod}; then
			sed "s/\(build_${mod}=\).*/\1m/I" -i mconfig || die
			if use modules; then
				for module_name in $(XA_get_module_name ${mod}); do
					MODULE_NAMES+=" ${module_name}"
				done
			fi
		else
			sed "s/\(build_${mod}=\).*/\1n/I" -i mconfig || die
		fi
	done
	einfo "${MODULE_NAMES}" # for debugging

	sed -e 's/depmod -a/true/' -i Makefile.in || die
	sed -e '/^all-local:/{s: modules::}' \
		-e '/^install-exec-local:/{s: modules_install::}' \
			-i extensions/Makefile.in || die

	use xtables_addons_geoip || sed  -e '/^SUBDIRS/{s/geoip//}' -i Makefile.in
}

src_configure() {
	set_arch_to_kernel # .. or it'll look for /arch/amd64/Makefile
	econf --prefix="${EPREFIX}/" \
		--libexecdir="${EPREFIX}/$(get_libdir)/" \
		--with-kbuild="${KV_DIR}"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" V=1
	use modules && BUILD_PARAMS="V=1" BUILD_TARGETS="modules" linux-mod_src_compile
}

src_install() {
	emake DESTDIR="${D}" install
	use modules && linux-mod_src_install
	dodoc -r README doc/*
	find "${ED}" -type f -name '*.la' -exec rm -rf '{}' '+'
}
