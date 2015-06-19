# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libpciaccess/libpciaccess-0.13.2.ebuild,v 1.14 2015/03/03 11:40:50 dlan Exp $

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="Library providing generic access to the PCI bus and devices"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal zlib"

DEPEND="!<x11-base/xorg-server-1.5
	zlib? (	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	sys-apps/hwids"

pkg_setup() {
	xorg-2_pkg_setup

	XORG_CONFIGURE_OPTIONS=(
		"$(use_with zlib)"
		"--with-pciids-path=${EPREFIX}/usr/share/misc"
	)
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		dodir /usr/bin
		${BASH} "${BUILD_DIR}/libtool" --mode=install "$(type -P install)" -c scanpci/scanpci "${ED}"/usr/bin || die
	fi
}
