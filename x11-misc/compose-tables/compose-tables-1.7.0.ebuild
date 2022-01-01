# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_STATIC=no
XORG_MULTILIB=no
inherit xorg-3

# xorg-3.eclass would attempt to fetch a tarball with a matching name to this package
SRC_URI="${XORG_BASE_INDIVIDUAL_URI}/lib/libX11-${PV}.tar.${XORG_TARBALL_SUFFIX}"
S="${WORKDIR}/libX11-${PV}/"

DESCRIPTION="X.Org Compose Key tables from libX11"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

# Only needed by configure
DEPEND="
	x11-base/xorg-proto
	>=x11-libs/libxcb-1.11.1
	x11-libs/xtrans"
RDEPEND="!<x11-libs/libX11-1.7.0"

XORG_CONFIGURE_OPTIONS=(
	--without-xmlto
	--without-fop
	--disable-specs
	--disable-xkb
)

src_compile() {
	emake -C nls
}

src_install() {
	emake DESTDIR="${D}" -C nls install
}

src_test() {
	:;
}
