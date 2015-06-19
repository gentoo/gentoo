# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-text/go-text-9999.ebuild,v 1.5 2015/06/09 03:07:26 zmedico Exp $

EAPI=5
inherit git-r3

KEYWORDS=""
DESCRIPTION="Go text processing support"
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
	rm -rf "${GOROOT}/src/${GO_PN}" \
		"${GOROOT}/pkg/linux_${ARCH}/${GO_PN}" || die
	GOROOT="${GOROOT}" GOPATH=${WORKDIR} go install -v -x -work ${GO_PN}/... || die
}

src_test() {
	# Create go symlink for TestLinking in display/dict_test.go
	mkdir -p "${GOROOT}/bin"
	ln -s /usr/bin/go  "${GOROOT}/bin/go" || die

	GOROOT="${GOROOT}" GOPATH=${WORKDIR} \
		go test -x -v ${GO_PN}/... || die $?
}

src_install() {
	exeinto /usr/lib/go/bin
	doexe "${WORKDIR}"/bin/*
	insinto /usr/lib/go
	find "${WORKDIR}"/{pkg,src} -name '.git*' -exec rm -rf {} \; 2>/dev/null
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r "${WORKDIR}"/{pkg,src}
}
