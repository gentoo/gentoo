# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
XORG_EAUTORECONF=yes
inherit xorg-3

DESCRIPTION="Library providing generic access to the PCI bus and devices"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="zlib"

DEPEND="
	zlib? (	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	sys-apps/hwids"

src_prepare() {
	# Let autotools install scanpci (#765706)
	sed 's@^noinst_@bin_@' -i scanpci/Makefile.am || die
	xorg-3_src_prepare
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_with zlib)
		--with-pciids-path="${EPREFIX}"/usr/share/misc
	)
	xorg-3_src_configure
}
