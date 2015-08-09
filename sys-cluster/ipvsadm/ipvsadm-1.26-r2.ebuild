# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils linux-info toolchain-funcs

DESCRIPTION="utility to administer the IP virtual server services"
HOMEPAGE="http://linuxvirtualserver.org/"
SRC_URI="http://www.linuxvirtualserver.org/software/kernel-2.6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 s390 sparc x86"
IUSE="static-libs"

RDEPEND=">=sys-libs/ncurses-5.2
	dev-libs/libnl:1.1
	>=dev-libs/popt-1.16"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	if kernel_is 2 4; then
		eerror "${P} supports only 2.6 series and later kernels, please try ${PN}-1.21 for 2.4 kernels"
		die "wrong kernel version"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch
	epatch "${FILESDIR}/${P}-stack_smashing.patch" # bug 371903
	use static-libs && export STATIC=1
}

src_compile() {
	emake -e \
		INCLUDE="-I.. -I." \
		CC="$(tc-getCC)" \
		HAVE_NL=1 \
		STATIC_LIB=${STATIC} \
		POPT_LIB="$(pkg-config --libs popt)"
}

src_install() {
	into /
	dosbin ipvsadm ipvsadm-save ipvsadm-restore

	into /usr
	doman ipvsadm.8 ipvsadm-save.8 ipvsadm-restore.8

	newinitd "${FILESDIR}"/ipvsadm-init ipvsadm
	keepdir /var/lib/ipvsadm

	use static-libs && dolib.a libipvs/libipvs.a
	dolib.so libipvs/libipvs.so

	insinto /usr/include/ipvs
	newins libipvs/libipvs.h ipvs.h
}

pkg_postinst() {
	einfo "You will need a kernel that has ipvs patches to use LVS."
}
