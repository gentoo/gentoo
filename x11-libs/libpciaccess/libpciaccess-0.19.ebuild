# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes
inherit dot-a xorg-meson

DESCRIPTION="Library providing generic access to the PCI bus and devices"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
IUSE="zlib static-libs"

DEPEND="
	zlib? (	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	sys-apps/hwdata"

src_configure() {
	use static-libs && lto-guarantee-fat

	local XORG_CONFIGURE_OPTIONS=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		-Dpci-ids="${EPREFIX}"/usr/share/hwdata
		$(meson_feature zlib)
	)
	xorg-meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	strip-lto-bytecode
}
