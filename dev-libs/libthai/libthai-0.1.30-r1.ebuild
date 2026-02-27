# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Set of Thai language support routines"
HOMEPAGE="
	https://linux.thai.net/projects/libthai
	https://github.com/tlwg/libthai
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tlwg/${PN}.git"
else
	SRC_URI="https://github.com/tlwg/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1+"
# Subslot: LT_CURRENT - LT_AGE from configure.ac (3 - 3 = 0)
SLOT="0/0"
IUSE="doc"

RDEPEND="dev-libs/libdatrie:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( >=app-text/doxygen-1.15.0 )"

src_configure() {
	econf \
		$(use_enable doc doxygen-doc) \
		--with-html-docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
