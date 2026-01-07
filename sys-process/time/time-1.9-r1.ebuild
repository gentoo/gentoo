# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Displays info about resources used by a program"
HOMEPAGE="https://www.gnu.org/directory/time.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9-implicit-func-decl-clang.patch
)

src_configure() {
	# https://savannah.gnu.org/bugs/index.php?66450
	append-cflags -std=gnu17

	econf
}
