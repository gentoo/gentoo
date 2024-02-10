# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Automatically execute scripts as you traverse directories"
HOMEPAGE="https://swapoff.org/OnDir"
SRC_URI="https://swapoff.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DOCS=( AUTHORS ChangeLog INSTALL scripts.tcsh scripts.sh )

src_prepare() {
	default
	sed -i \
		-e "s:\(/man/.*$\):/share\1:g" \
		-e "s#^CFLAGS=\(.*\)#CFLAGS= \1 ${CFLAGS}#g;" \
		-e "s#^LDFLAGS=\(.*\)#LDFLAGS= \1 ${LDFLAGS}#g;" \
		-i Makefile || die "sed Makefile failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr" \
		CONF="${EPREFIX}/etc/ondirrc"
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
