# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A free MASM-compatible assembler based on JWasm"
HOMEPAGE="http://www.terraspace.co.uk/uasm.html"
SRC_URI="https://github.com/Terraspace/UASM/archive/refs/heads/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Watcom-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""
BDEPEND=""

S="${WORKDIR}/UASM-${PV}"
B_DIR="${WORKDIR}/build"

src_prepare() {
	default
	
	# fix sources
	eapply -p0 "${FILESDIR}/${PN}-2.52-dbgcv.patch"
	sed -E -e 's|(#ifndef _TYPES_H_INCLUDED)\>|\1_|g' -i H/types.h || die
	
	sed -E -e '/^extra_c_flags ?=/ { s/ (-O2|-g)\>//g ;' \
		-e ' s/ ?= ?/ = $(CFLAGS) / ; } ' \
		-e '/^	\$\(CC\).*map\>/ { s|\$\(CC\)|\$(CC) \$(LDFLAGS)| ;' \
		-e ' s/ -s\>//g ; }' \
		-i Makefile_Linux gccLinux64.mak ClangOSX64.mak || die
}

src_compile() {
	local emake_params=( )
	emake_params+=(
		-f gccLinux64.mak
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS} -fcommon"
		LDFLAGS="${LDFLAGS}"
		OUTD="${B_DIR}"
	)
	
	emake "${emake_params[@]}"
	
	mkdir -p "${B_DIR}"/include/uasm || die
	cp "${S}"/Reference_Macros/* "${B_DIR}"/include/uasm || die
}

src_install() {
	dobin "${B_DIR}/${PN}"

	doheader -r "${B_DIR}"/include/uasm

	use doc && dodoc History.txt License.txt Readme.txt README.md
}
