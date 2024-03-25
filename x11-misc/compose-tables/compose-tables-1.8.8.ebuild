# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=no
XORG_TARBALL_SUFFIX=xz
inherit xorg-3

# Note: please bump this with x11-libs/libX11
DESCRIPTION="X.Org Compose Key tables from libX11"
# xorg-3.eclass would attempt to fetch a tarball with a matching name to this package
SRC_URI="${XORG_BASE_INDIVIDUAL_URI}/lib/libX11-${PV}.tar.${XORG_TARBALL_SUFFIX}"
S="${WORKDIR}/libX11-${PV}/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# Only needed by configure
DEPEND="
	x11-base/xorg-proto
	>=x11-libs/libxcb-1.11.1
	x11-libs/xtrans"
# RDEPEND=""

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--without-xmlto
		--without-fop
		--disable-specs
		--disable-xkb
		--with-keysymdefdir="${ESYSROOT}/usr/include/X11"
	)
	xorg-3_src_configure
}

src_compile() {
	emake -C nls
}

src_test() {
	:;
}

src_install() {
	emake DESTDIR="${D}" -C nls install
}
