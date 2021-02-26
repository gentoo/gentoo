# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="RC init files for starting display and login managers"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:X11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}"

RDEPEND="
	sys-apps/gentoo-functions
	!<=sys-apps/sysvinit-2.98
	!<=x11-apps/xinit-1.4.1
	!<=x11-base/xorg-server-1.20.10
	!=x11-base/xorg-server-1.20.10-r2
"

src_install() {
	newinitd "${FILESDIR}"/display-manager-setup.initd display-manager-setup
	newinitd "${FILESDIR}"/display-manager.initd-r1 display-manager
	newinitd "${FILESDIR}"/xdm.initd xdm
	newconfd "${FILESDIR}"/display-manager.confd display-manager
	newbin "${FILESDIR}"/startDM-r1 startDM
	# backwards compatibility
	dosym "${ESYSROOT}"/usr/bin/startDM /etc/X11/startDM.sh
}

pkg_preinst() {
	if [[ ${REPLACING_VERSIONS} == "" && -f "${EROOT}"/etc/conf.d/xdm && ! -f "${EROOT}"/etc/conf.d/display-manager ]]; then
		cp -a "${EROOT}"/etc/conf.d/{xdm,display-manager} || die
	fi
	local rlevel using_xdm
	using_xdm=no
	for rlevel in boot default sysinit; do
		if [[ -e "${EROOT}"/etc/runlevels/${rlevel}/xdm ]]; then
			using_xdm=yes
		fi
	done
	if [[ "${using_xdm}" = "yes" ]]; then
		ewarn "The 'xdm' service has been replaced by new 'display-manager'"
		ewarn "service, please switch now:"
		ewarn
		ewarn "  # rc-update del xdm default"
		ewarn "  # rc-update add display-manager default"
		ewarn
		ewarn "Remember to run etc-update or dispatch-conf to update the"
		ewarn "config protected service files."
	fi
}
