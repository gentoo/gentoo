# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN=golang.org/x/net/...
EGO_SRC=golang.org/x/net

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="b6d7b1396ec874c3b00f6c84cd4301a17c56c8ed"
	SRC_URI="https://github.com/golang/net/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://godoc.org/golang.org/x/net"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND="dev-go/go-crypto:=
	dev-go/go-text:="
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestReadProppatch(:_\0:' \
		-i src/${EGO_SRC}/webdav/xml_test.go || die
	sed -e 's:TestPingGoogle(:_\0:' \
		-e 's:TestNonPrivilegedPing(:_\0:' \
		-i src/${EGO_SRC}/icmp/ping_test.go || die
}

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" || die
	export GOROOT="${T}/goroot"
	golang-build_src_compile
}
