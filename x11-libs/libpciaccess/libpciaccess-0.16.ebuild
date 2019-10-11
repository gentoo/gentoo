# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="Library providing generic access to the PCI bus and devices"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="zlib"

DEPEND="!<x11-base/xorg-server-1.5
	zlib? (	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	sys-apps/hwids"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		"$(use_with zlib)"
		"--with-pciids-path=${EPREFIX}/usr/share/misc"
	)
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		dodir /usr/bin
		/bin/sh libtool --mode=install "$(type -P install)" -c scanpci/scanpci "${ED}"/usr/bin || die
	fi
}
