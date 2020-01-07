# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Linux port of OpenBSD's ksh"
HOMEPAGE="https://github.com/dimkr/loksh"
SRC_URI="https://github.com/dimkr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="sys-libs/ncurses:0="
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}
	!app-shells/ksh"

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake \
		BIN_DIR="${EROOT}/bin" \
		DESTDIR="${D}" \
		DOC_DIR="${EPREFIX}/usr/share/doc/${PF}" \
		install

	dodoc NOTES
}
