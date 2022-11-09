# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of patches for libtool.eclass"
HOMEPAGE="https://gitweb.gentoo.org/proj/elt-patches.git/"
SRC_URI="https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz
	https://dev.gentoo.org/~vapier/dist/${P}.tar.xz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

RDEPEND="sys-apps/gentoo-functions"
BDEPEND="app-arch/xz-utils"

src_compile() {
	emake rootprefix="${EPREFIX}" libdirname="$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" rootprefix="${EPREFIX}" install
}
