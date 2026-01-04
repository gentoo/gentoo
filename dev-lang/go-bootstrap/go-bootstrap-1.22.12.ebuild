# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Binary bootstrap package for dev-lang/go"
HOMEPAGE="https://golang.org"
BOOTSTRAP_DIST="https://dev.gentoo.org/~williamh/dist"
SRC_URI="
	x64-macos? ( ${BOOTSTRAP_DIST}/${P}-darwin-amd64.tbz )
	arm64-macos? ( ${BOOTSTRAP_DIST}/${P}-darwin-arm64.tbz )
	x86? ( ${BOOTSTRAP_DIST}/${P}-linux-386.tbz )
	amd64? ( ${BOOTSTRAP_DIST}/${P}-linux-amd64.tbz )
	arm64? ( ${BOOTSTRAP_DIST}/${P}-linux-arm64.tbz )
	arm? ( ${BOOTSTRAP_DIST}/${P}-linux-arm.tbz )
	loong? ( ${BOOTSTRAP_DIST}/${P}-linux-loong64.tbz )
	mips? (
		abi_mips_n64? (
			!big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-mips64le.tbz )
			big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-mips64.tbz )
		)
		abi_mips_o32? (
			!big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-mipsle.tbz )
			big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-mips.tbz )
		)
	)
	ppc64? (
		!big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-ppc64le.tbz )
		big-endian? ( ${BOOTSTRAP_DIST}/${P}-linux-ppc64.tbz )
	)
	riscv? ( ${BOOTSTRAP_DIST}/${P}-linux-riscv64.tbz )
	s390? ( ${BOOTSTRAP_DIST}/${P}-linux-s390x.tbz )
	x64-solaris? ( ${BOOTSTRAP_DIST}/${P}-solaris-amd64.tbz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 arm arm64 ~loong ~mips ppc64 ~riscv ~s390 x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="abi_mips_n64 abi_mips_o32 big-endian"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	dodir /usr/lib
	mv go-*-bootstrap "${ED}/usr/lib/go-bootstrap" || die

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}"/usr/lib/go-bootstrap -iname testdata -type d -print)
}
