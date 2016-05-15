# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN=golang.org/x/text/...
EGO_SRC=golang.org/x/text

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="df923bbb63f8ea3a26bb743e2a497abd0ab585f7"
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

src_test() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	if [ -d "${T}/goroot/src/${EGO_SRC}" ]; then
		rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	fi
	if [ -d "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" ]; then
		rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" ||
			die
	fi

	# Create go symlink for TestLinking in display/dict_test.go
	mkdir -p "${T}/goroot/bin"
	ln -s /usr/bin/go  "${T}/goroot/bin/go" || die

	GOROOT="${T}/goroot" golang-build_src_test
}

src_install() {
	golang-build_src_install
	dobin bin/*
}
