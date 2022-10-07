# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bootstrap package for dev-lang/go"
HOMEPAGE="https://golang.org"
BOOTSTRAP_DIST="https://dev.gentoo.org/~williamh/dist"
SRC_URI="
	amd64? ( ${BOOTSTRAP_DIST}/go-linux-amd64-bootstrap-${PV}.tbz )
	arm? ( ${BOOTSTRAP_DIST}/go-linux-arm-bootstrap-${PV}.tbz )
	arm64? ( ${BOOTSTRAP_DIST}/go-linux-arm64-bootstrap-${PV}.tbz )
	ppc64? (
		big-endian? ( ${BOOTSTRAP_DIST}/go-linux-ppc64-bootstrap-${PV}.tbz )
		!big-endian? ( ${BOOTSTRAP_DIST}/go-linux-ppc64le-bootstrap-${PV}.tbz )
	)
	riscv? ( ${BOOTSTRAP_DIST}/go-linux-riscv64-bootstrap-${PV}.tbz )
	s390? ( ${BOOTSTRAP_DIST}/go-linux-s390x-bootstrap-${PV}.tbz )
	x86? ( ${BOOTSTRAP_DIST}/go-linux-386-bootstrap-${PV}.tbz )
	x64-macos? ( ${BOOTSTRAP_DIST}/go-darwin-amd64-bootstrap-${PV}.tbz )
	x64-solaris? ( ${BOOTSTRAP_DIST}/go-solaris-amd64-bootstrap-${PV}.tbz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 arm arm64 ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="big-endian"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	dodir /usr/lib
	mv go-*-bootstrap "${ED}/usr/lib/go-bootstrap" || die

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}"/usr/lib/go-bootstrap -iname testdata -type d -print)
}
