# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_PN=${PN}Src

DESCRIPTION="The BLAST-Like Alignment Tool, a fast genomic sequence aligner"
HOMEPAGE="http://www.cse.ucsc.edu/~kent/"
SRC_URI="http://www.soe.ucsc.edu/~kent/src/${MY_PN}${PV}.zip"

LICENSE="blat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

PATCHES=( "${FILESDIR}"/${PN}-34-fix-build-system.patch )

src_compile() {
	tc-export AR CC

	export HOME="${S}"
	export MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"

	mkdir -p bin/${MACHTYPE} || die
	default
}

src_install() {
	export MACHTYPE=$(tc-arch)
	[[ ${MACHTYPE} == "x86" ]] && MACHTYPE="i386"

	dobin bin/${MACHTYPE}/*
}
