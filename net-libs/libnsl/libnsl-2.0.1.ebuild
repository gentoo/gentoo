# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal preserve-libs

DESCRIPTION="Public client interface for NIS(YP) in a IPv6 ready version"
HOMEPAGE="https://github.com/thkukuk/libnsl"
SRC_URI="https://github.com/thkukuk/${PN}/releases/download/v${PV}/${P}.tar.xz"

# This is a core package which is depended on by e.g. PAM in some cases.
# Please use preserve-libs.eclass in pkg_{pre,post}inst to cover users
# with FEATURES="-preserved-libs" or another package manager if SONAME
# changes.
SLOT="0/3"
LICENSE="LGPL-2.1+ BSD"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=">=net-libs/libtirpc-1.2.0:=[${MULTILIB_USEDEP}]"
RDEPEND="
	${DEPEND}
	!<sys-libs/glibc-2.26
"

multilib_src_configure() {
	local myconf=(
		--enable-shared
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libnsl.so.2
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libnsl.so.2
}
