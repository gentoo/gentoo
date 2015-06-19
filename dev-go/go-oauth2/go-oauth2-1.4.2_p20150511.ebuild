# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-oauth2/go-oauth2-1.4.2_p20150511.ebuild,v 1.1 2015/05/25 07:04:51 zmedico Exp $

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="Go client implementation for OAuth 2.0 spec"
MY_PN=${PN##*-}
GO_PN=golang.org/x/${MY_PN}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_COMMIT="f98d0160877ab4712b906626425ed8b0b320907c"
SRC_URI="https://${GO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/GoogleCloudPlatform/gcloud-golang/archive/629ed086d82ad5d0ac3668e309b8785aaf54735b.tar.gz -> gcloud-golang-629ed086d82ad5d0ac3668e309b8785aaf54735b.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-lang/go-1.4
	dev-go/go-net"
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"
STRIP_MASK="*.a"

src_unpack() {
	default
	mkdir -p src/${GO_PN%/*} || die
	mv ${MY_PN}-${EGIT_COMMIT} src/${GO_PN} || die

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot" GOPATH=${WORKDIR}
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" || die

	mkdir -p "${GOROOT}/src/google.golang.org" || die
	rm -rf "${GOROOT}/src/google.golang.org"/* || die
	rm -rf "${GOROOT}/pkg/${KERNEL}_${ARCH}/google.golang.org" || die
	mv gcloud-golang-629ed086d82ad5d0ac3668e309b8785aaf54735b "${GOROOT}/src/google.golang.org/cloud" || die
}

src_compile() {
	go install -v -x -work google.golang.org/cloud/compute/metadata || die
	go install -v -x -work ${GO_PN}/... || die
}

src_test() {
	# google/example_test.go imports appengine, introducing a circular dep
	mv google/example_test.go{,_}
	go test -x -v ${GO_PN}/... || die $?
	mv google/example_test.go{_,}
}

src_install() {
	insinto /usr/lib/go
	find "${WORKDIR}"/{pkg,src} -name '.git*' -exec rm -rf {} \; 2>/dev/null
	doins -r "${WORKDIR}"/{pkg,src}
}
