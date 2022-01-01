# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Collection of patches for libtool.eclass"
HOMEPAGE="https://gitweb.gentoo.org/proj/elt-patches.git/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~arm64-linux ~ppc64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

DEPEND="app-arch/xz-utils"

src_install() {
	insinto /usr/share/elt-patches
	doins -r .
}
