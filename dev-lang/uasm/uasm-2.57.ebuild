# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="UASM is a free MASM-compatible assembler"
HOMEPAGE="https://www.terraspace.co.uk/uasm.html"
TAG="${PV}r"  # the tag has a 'r' suffix (2.57r) for some reason
SRC_URI="https://github.com/Terraspace/UASM/archive/v${TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/UASM-${TAG}"

LICENSE="Watcom-1.0"
SLOT="0"
KEYWORDS="amd64"
PATCHES=(
	"${FILESDIR}/build-fix.patch"
	"${FILESDIR}/makefile-dep-fix-2.57.patch"
	"${FILESDIR}/bool-fix.diff"
)

src_prepare() {
	default
	# don't strip binary
	sed -i Makefile-Linux-GCC-64.mak -e 's/ -s / /g' || die
}

src_compile() {
	# BUG: https://github.com/Terraspace/UASM/issues/143
	append-cflags -fcommon
	# BUG: https://github.com/Terraspace/UASM/issues/197
	append-cflags -Wno-error=incompatible-pointer-types
	# BUG: 951108
	append-cflags -std=gnu17

	emake -f Makefile-Linux-GCC-64.mak \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin GccUnixR/uasm
	dodoc *.txt Doc/*.txt
}
