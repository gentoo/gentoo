# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-text/go-text-0_pre20150604.ebuild,v 1.1 2015/07/01 21:17:54 williamh Exp $

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="Go text processing support"
MY_PN=${PN##*-}
GO_PN=golang.org/x/${MY_PN}
HOMEPAGE="https://godoc.org/${GO_PN}"
EGIT_COMMIT="df923bbb63f8ea3a26bb743e2a497abd0ab585f7"
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
