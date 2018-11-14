# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-info toolchain-funcs

DESCRIPTION="utility to administer the IP virtual server services"
HOMEPAGE="http://linuxvirtualserver.org/"
SRC_URI="https://kernel.org/pub/linux/utils/kernel/ipvsadm/ipvsadm-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="static-libs"

RDEPEND=">=sys-libs/ncurses-5.2:*
	dev-libs/libnl:=
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
	default
	epatch "${FILESDIR}"/${PN}-1.27-buildsystem.patch
	epatch "${FILESDIR}"/${PN}-1.27-fix-daemon-state.patch
	use static-libs && export STATIC=1
}

src_compile() {
	local libnl_include
	if has_version ">=dev-libs/libnl-3.0"; then
		libnl_include=$(pkg-config --cflags libnl-3.0)
	else
		libnl_include=""
	fi
	emake -e \
		INCLUDE="-I.. -I. ${libnl_include}" \
		CC="$(tc-getCC)" \
		HAVE_NL=1 \
		STATIC=${STATIC} \
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
