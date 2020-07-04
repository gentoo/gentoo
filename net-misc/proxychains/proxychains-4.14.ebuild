# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=${PN}-ng
MY_P=${MY_PN}-${PV}

DESCRIPTION="force any tcp connections to flow through a proxy (or proxy chain)"
HOMEPAGE="https://github.com/rofl0r/proxychains-ng/"
SRC_URI="http://ftp.barfooze.de/pub/sabotage/tarballs/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	sed -i "s/^\(LDSO_SUFFIX\).*/\1 = so.${PV}/" Makefile || die
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
	dodoc AUTHORS README TODO

	dolib.so lib${PN}.so.${PV}
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	insinto /etc
	doins src/${PN}.conf
}
