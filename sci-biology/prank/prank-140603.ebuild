# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/prank/prank-140603.ebuild,v 1.1 2015/03/29 13:52:32 jlec Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="Probabilistic Alignment Kit"
HOMEPAGE="http://wasabiapp.org/software/prank/"
SRC_URI="http://wasabiapp.org/download/${PN}/${PN}.source.${PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-msa/src"

src_prepare() {
	sed \
		-e "s/\$(LINK)/& \$(LDFLAGS)/" \
		-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		-i Makefile || die
}

src_compile() {
	emake \
		LINK="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin ${PN}
}
