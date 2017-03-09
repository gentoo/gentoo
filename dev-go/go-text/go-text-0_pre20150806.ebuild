# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_PN=golang.org/x/text/...
EGO_SRC=golang.org/x/text

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="1309a1875a4368c12688b9383c6bcac738c17c29"
	SRC_URI="https://github.com/golang/text/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go text processing support"
HOMEPAGE="https://godoc.org/golang.org/x/text"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" || die
	export GOROOT="${T}/goroot"
	golang-build_src_compile
}

src_test() {
	# Create go symlink for TestLinking in display/dict_test.go
	mkdir -p "${GOROOT}/bin"
	ln -s /usr/bin/go  "${GOROOT}/bin/go" || die
	golang-build_src_test
}

src_install() {
	golang-build_src_install
	export -n GOROOT
	exeopts -m0755 -p # preserve timestamps for bug 551486
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
}
