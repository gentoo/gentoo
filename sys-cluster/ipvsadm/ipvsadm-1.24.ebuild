# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ipvsadm/ipvsadm-1.24.ebuild,v 1.30 2015/03/21 22:08:57 jlec Exp $

inherit linux-info toolchain-funcs

DESCRIPTION="utility to administer the IP virtual server services offered by the Linux kernel"
HOMEPAGE="http://linuxvirtualserver.org/"
SRC_URI="http://www.linuxvirtualserver.org/software/kernel-2.5/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc64 s390 sparc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="${RDEPEND}"

pkg_setup() {
	if kernel_is 2 4; then
		eerror "${P} supports only 2.6 kernels, please try ${PN}-1.21 for 2.4 kernels"
		die "wrong kernel version"
	fi
}

src_compile() {
	emake \
		-j1 \
		INCLUDE="-I${KV_DIR}/include -I.. -I." \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		 || die "error compiling source"
}

src_install() {
	into /
	dosbin ipvsadm ipvsadm-save ipvsadm-restore || die

	doman ipvsadm.8 ipvsadm-save.8 ipvsadm-restore.8 || die

	newinitd "${FILESDIR}"/ipvsadm-init ipvsadm
	keepdir /var/lib/ipvsadm

	dolib.a libipvs/libipvs.a || die

	insinto /usr/include/ipvs
	newins libipvs/libipvs.h ipvs.h || die
}

pkg_postinst() {
	einfo "You will need a kernel that has ipvs patches to use LVS."
	einfo "This version is specifically for 2.6 kernels."
}
