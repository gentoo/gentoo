# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base

KEYWORDS="~amd64"
DESCRIPTION="Go client implementation for OAuth 2.0 spec"
MY_PN=${PN##*-}
GO_PN=golang.org/x/${MY_PN}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_COMMIT="8914e5017ca260f2a3a1575b1e6868874050d95e"
SRC_URI="https://github.com/golang/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/GoogleCloudPlatform/gcloud-golang/archive/e34a32f9b0ecbc0784865fb2d47f3818c09521d4.tar.gz -> gcloud-golang-e34a32f9b0ecbc0784865fb2d47f3818c09521d4.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net"
RDEPEND=""
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"
STRIP_MASK="*.a"

src_unpack() {
	default
	mkdir -p src/${GO_PN%/*} || die
	mv ${MY_PN}-${EGIT_COMMIT} src/${GO_PN} || die

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot" GOPATH="${WORKDIR}/:$(get_golibdir_gopath)"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${GO_PN}" || die

	mkdir -p "${GOROOT}/src/google.golang.org" || die
	rm -rf "${GOROOT}/src/google.golang.org"/* || die
	rm -rf "${GOROOT}/pkg/${KERNEL}_${ARCH}/google.golang.org" || die
	mv gcloud-golang-e34a32f9b0ecbc0784865fb2d47f3818c09521d4 "${GOROOT}/src/google.golang.org/cloud" || die
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
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r "${WORKDIR}"/{pkg,src}
}
