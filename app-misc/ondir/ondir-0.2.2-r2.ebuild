# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Automatically execute scripts as you traverse directories"
HOMEPAGE="http://swapoff.org/OnDir"
SRC_URI="http://swapoff.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README INSTALL scripts.tcsh scripts.sh )
HTML_DOCS=(  changelog.html ondir.1.html )

src_prepare() {
	default
	sed -i \
		-e "s:\(/man/.*$\):/share\1:g" \
		-e "s:-g:${CFLAGS}:" Makefile || die "sed Makefile failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr" \
		CONF="${EPREFIX}/etc/ondirrc" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	default
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		CONF="${EPREFIX}/etc/ondirrc" \
		install
	newdoc ondirrc.eg ondirrc.example
}
