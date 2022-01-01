# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="RC init files for starting display and login managers"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:X11"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

S="${FILESDIR}"

RDEPEND="
	sys-apps/gentoo-functions
	!<=sys-apps/sysvinit-2.98
	!<=x11-apps/xinit-1.4.1
	!<=x11-base/xorg-server-1.20.10
"

src_install() {
	newinitd "${FILESDIR}"/display-manager-setup.initd display-manager-setup
	newinitd "${FILESDIR}"/display-manager.initd display-manager
	newinitd "${FILESDIR}"/xdm.initd xdm
	newconfd "${FILESDIR}"/display-manager.confd display-manager
	exeinto /usr/bin
	doexe "${FILESDIR}"/startDM
	# backwards compatibility
	dosym "${ESYSROOT}"/usr/bin/startDM /etc/X11/startDM.sh
}

pkg_preinst() {
	if [[ ${REPLACING_VERSIONS} == "" && -f "${EROOT}"/etc/conf.d/xdm && ! -f "${EROOT}"/etc/conf.d/display-manager ]]; then
		mv "${EROOT}"/etc/conf.d/{xdm,display-manager} || die
	fi
	local rlevel using_xdm
	using_xdm=no
	for rlevel in boot default sysinit; do
		if [[ -e "${EROOT}"/etc/runlevels/${rlevel}/xdm ]]; then
			using_xdm=yes
		fi
	done
	if [[ "${using_xdm}" = "yes" ]]; then
		ewarn "The 'xdm' service has been removed as it is"
		ewarn "being replaced by the 'display-manager' service."
		ewarn "Please migrate to using 'display-manager' and"
		ewarn "remember to use dispatch-conf to update the"
		ewarn "config protected service files."
	fi
}
