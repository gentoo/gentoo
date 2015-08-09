# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
