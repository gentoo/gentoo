# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-sys/go-sys-1.4.2_p20150518-r1.ebuild,v 1.1 2015/06/09 03:28:08 zmedico Exp $

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="Go packages for low-level interaction with the operating system"
MY_PN=${PN##*-}
GO_PN=golang.org/x/${MY_PN}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_COMMIT="58e109635f5d754f4b3a8a0172db65a52fcab866"
SRC_URI="https://github.com/golang/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.4"
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"
STRIP_MASK="*.a"

src_unpack() {
	default
	mkdir -p src/${GO_PN%/*} || die
	mv ${MY_PN}-${EGIT_COMMIT} src/${GO_PN} || die
}

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN%%/*}" \
		"${GOROOT}/pkg/linux_${ARCH}/${GO_PN%%/*}" || die
	GOROOT="${GOROOT}" GOPATH=${WORKDIR} \
		go install -x -v -work ${GO_PN}/unix/... || die
}

src_test() {
	GOROOT="${GOROOT}" GOPATH=${WORKDIR} \
		go test -x -v golang.org/x/sys/unix/... || die
}

src_install() {
	insinto /usr/lib/go
	doins -r "${WORKDIR}"/pkg
	insinto /usr/lib/go/src/${GO_PN}
	find "${WORKDIR}"/src/${GO_PN} -name '.git*' -exec \
		rm -rf {} \; 2>/dev/null
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r "${WORKDIR}"/src/${GO_PN}/unix
}
