# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/blat/blat-34-r1.ebuild,v 1.2 2011/08/04 19:46:21 grobian Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_PN="${PN}Src"

DESCRIPTION="The BLAST-Like Alignment Tool, a fast genomic sequence aligner"
HOMEPAGE="http://www.cse.ucsc.edu/~kent/"
SRC_URI="http://www.soe.ucsc.edu/~kent/src/${MY_PN}${PV}.zip"

SLOT="0"
LICENSE="blat"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

S="${WORKDIR}/${MY_PN}"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	sed \
		-e "1i\CFLAGS=${CFLAGS}" \
		-e "1i\LDFLAGS=${LDFLAGS}" \
		-i inc/common.mk || die
	tc-export CC
}

src_compile() {
	MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"
	mkdir -p "${S}/bin/${MACHTYPE}"
	emake MACHTYPE="${MACHTYPE}" HOME="${S}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"
	dobin "${S}/bin/${MACHTYPE}/"*
}
