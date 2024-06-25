# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of patches for libtool.eclass"
HOMEPAGE="https://gitweb.gentoo.org/proj/elt-patches.git/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/elt-patches.git
		https://github.com/gentoo/elt-patches
	"
	inherit git-r3
else
	SRC_URI="
		https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz
		https://dev.gentoo.org/~vapier/dist/${P}.tar.xz
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz
	"

	KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~arm64-linux ~ppc64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
# The 'check' target currently wants network access to fetch libtool tarballs.
RESTRICT="test"

RDEPEND="sys-apps/gentoo-functions"
BDEPEND="app-arch/xz-utils"

src_compile() {
	emake rootprefix="${EPREFIX}" libdirname="$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" rootprefix="${EPREFIX}" install
}
