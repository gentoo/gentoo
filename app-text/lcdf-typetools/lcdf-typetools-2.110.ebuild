# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Font utilities for eg manipulating OTF"
HOMEPAGE="
	https://lcdf.org/type/#typetools
	https://github.com/kohler/lcdf-typetools
"
SRC_URI="https://lcdf.org/type/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+kpathsea"

RDEPEND="kpathsea? ( virtual/tex-base dev-libs/kpathsea:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( NEWS.md README.md ONEWS )

src_configure() {
	# gcc ICE with LTO: https://gcc.gnu.org/PR100010
	filter-flags -fdevirtualize-at-ltrans

	if use kpathsea; then
		has_version 'dev-libs/kpathsea' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
	fi
	econf $(use_with kpathsea)
}
