# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-net/go-net-9999.ebuild,v 1.4 2015/06/08 19:34:50 zmedico Exp $

EAPI=5
inherit git-r3

KEYWORDS=""
DESCRIPTION="Go supplementary network libraries"
GO_PN=golang.org/x/${PN##*-}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_REPO_URI="https://go.googlesource.com/${PN##*-}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.4
	dev-go/go-text"
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"
STRIP_MASK="*.a"

src_prepare() {
	# disable broken tests
	sed -e 's:TestReadProppatch(:_\0:' -i webdav/xml_test.go || die
	sed -e 's:TestPingGoogle(:_\0:' \
		-e 's:TestNonPrivilegedPing(:_\0:' \
		-i icmp/ping_test.go || die
}

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" \
		"${GOROOT}/pkg/linux_${ARCH}/${GO_PN}" || die
	GOROOT="${GOROOT}" GOPATH=${WORKDIR} go install -v -x -work ${GO_PN}/... || die
}

src_test() {
	GOROOT="${GOROOT}" GOPATH=${WORKDIR} \
		go test -x -v ${GO_PN}/... || die $?
}

src_install() {
	insinto /usr/lib/go
	find "${WORKDIR}"/{pkg,src} -name '.git*' -exec rm -rf {} \; 2>/dev/null
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r "${WORKDIR}"/{pkg,src}
}
