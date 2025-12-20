# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="RC init files for starting display and login managers"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:X11"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	sys-apps/gentoo-functions
	!<=sys-apps/sysvinit-2.98
	!<=x11-apps/xinit-1.4.1
"

src_install() {
	newinitd "${FILESDIR}"/display-manager-setup.initd-r1 display-manager-setup
	newinitd "${FILESDIR}"/display-manager.initd-r6 display-manager
	newinitd "${FILESDIR}"/xdm.initd xdm
	newconfd "${FILESDIR}"/display-manager.confd display-manager
	newbin "${FILESDIR}"/startDM-r1 startDM
	# backwards compatibility
	dosym "${ESYSROOT}"/usr/bin/startDM /etc/X11/startDM.sh
}
