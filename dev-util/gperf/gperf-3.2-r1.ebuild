# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A perfect hash function generator"
HOMEPAGE="https://www.gnu.org/software/gperf/"
SRC_URI="mirror://gnu/gperf/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-c++.patch.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	"${WORKDIR}"/${P}-c++.patch
	"${FILESDIR}"/${P}-tests.patch
)

src_prepare() {
	default

	sed -i \
		-e "/^CPPFLAGS /s:=:+=:" \
		*/Makefile.in || die #444078
}

src_configure() {
	econf --cache-file="${S}"/config.cache
}
