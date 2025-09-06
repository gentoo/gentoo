# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN}-ng
MY_P=${MY_PN}-${PV}

DESCRIPTION="force any tcp connections to flow through a proxy (or proxy chain)"
HOMEPAGE="https://github.com/rofl0r/proxychains-ng/"
SRC_URI="https://ftp.barfooze.de/pub/sabotage/tarballs/${MY_P}.tar.xz"

S=${WORKDIR}/${MY_P}
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~sparc ~x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	sed -i "s/^\(LDSO_SUFFIX\).*/\1 = so.${PV}/" Makefile || die
	mv completions/zsh/_proxychains4 completions/zsh/_proxychains || die
	tc-export CC
}

src_configure() {
	# not autotools
	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--sysconfdir="${EPREFIX}"/etc \
		|| die
}

src_install() {
	dobin ${PN}
	dobin ${PN}-daemon
	dodoc AUTHORS README TODO

	dolib.so lib${PN}.so.${PV}
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	insinto /etc
	doins src/${PN}.conf
}
