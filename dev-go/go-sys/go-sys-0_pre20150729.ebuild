# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN=golang.org/x/sys/...
EGO_SRC=golang.org/x/sys

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
EGIT_COMMIT="58da1121af381632b48b2843aeb16299f2e1dc50"
	SRC_URI="https://github.com/golang/sys/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go packages for low-level interaction with the operating system"
HOMEPAGE="https://godoc.org/golang.org/x/sys"
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
