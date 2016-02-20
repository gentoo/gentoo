# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils golang-base

MY_PN=${PN##*-}
GO_PN=golang.org/x/${MY_PN}
EGIT_COMMIT="8914e5017ca260f2a3a1575b1e6868874050d95e"

HOMEPAGE="https://godoc.org/${GO_PN}"
DESCRIPTION="Go client implementation for OAuth 2.0 spec"
SRC_URI="
	https://github.com/golang/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/GoogleCloudPlatform/gcloud-golang/archive/872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz -> gcloud-golang-872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz"

SLOT="0/${PVR}"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-go/go-net:=
	dev-go/go-tools"
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
	mv gcloud-golang-872c736f496c2ba12786bedbb8325576bbdb33cf "${GOROOT}/src/google.golang.org/cloud" || die
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
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r "${WORKDIR}"/{pkg,src}
}
