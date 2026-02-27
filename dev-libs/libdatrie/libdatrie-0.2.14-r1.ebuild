# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Double-Array Trie Library"
HOMEPAGE="
	https://linux.thai.net/projects/datrie
	https://github.com/tlwg/libdatrie
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tlwg/${PN}.git"
else
	SRC_URI="https://github.com/tlwg/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+"
# Subslot: LT_CURRENT - LT_AGE from configure.ac (5 - 4 = 1)
SLOT="0/1"
IUSE="doc"

BDEPEND="doc? ( >=app-text/doxygen-1.9.8 )"

src_configure() {
	econf \
		$(use_enable doc doxygen-doc) \
		--with-html-docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
