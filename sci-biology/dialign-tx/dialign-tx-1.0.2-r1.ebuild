# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P=DIALIGN-TX_${PV}

DESCRIPTION="Greedy and progressive approaches for segment-based multiple sequence alignment"
HOMEPAGE="http://dialign-tx.gobics.de/"
SRC_URI="http://dialign-tx.gobics.de/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e "s/\$(CC) -o/\$(CC) \$(LDFLAGS) -o/" \
		-i source/Makefile || die #336533
	epatch	"${FILESDIR}"/${P}-implicits.patch \
		"${FILESDIR}"/${P}-modernize.patch
}

src_compile() {
	emake -C source clean
	emake -C source CC="$(tc-getCC)" \
		CPPFLAGS=""
}

src_install() {
	dobin "${S}"/source/dialign-tx
	insinto /usr/$(get_libdir)/${PN}/conf
	doins "${S}"/conf/*
}

pkg_postinst() {
	einfo "The configuration directory is"
	einfo "${ROOT}usr/$(get_libdir)/${PN}/conf"
	einfo "You will need to pass this to ${PN} on every run."
}
