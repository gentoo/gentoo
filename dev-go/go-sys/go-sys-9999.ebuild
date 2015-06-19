# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-sys/go-sys-9999.ebuild,v 1.2 2015/06/09 03:28:08 zmedico Exp $

EAPI=5
inherit git-r3

KEYWORDS=""
DESCRIPTION="Go packages for low-level interaction with the operating system"
GO_PN=golang.org/x/${PN##*-}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_REPO_URI="https://go.googlesource.com/${PN##*-}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.4"
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"
STRIP_MASK="*.a"

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
