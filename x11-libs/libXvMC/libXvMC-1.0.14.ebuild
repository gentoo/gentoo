# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3 meson-multilib

DESCRIPTION="X.Org XvMC library"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# Override xorg-3's src_prepare
src_prepare() {
	default
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=shared
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/share/doc/{${PN},${P}}/XvMC_API.txt || die
	rmdir "${ED}"/usr/share/doc/${PN} || die
}
