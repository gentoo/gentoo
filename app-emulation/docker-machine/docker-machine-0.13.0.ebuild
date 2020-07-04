# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/docker/machine

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Machine management for a container-centric world"
HOMEPAGE="https://docs.docker.com/machine/"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0 ZLIB"
SLOT="0"
IUSE="hardened"
RESTRICT="test"
S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	default
	# don't pre-strip binaries
	sed -e 's|\(GO_LDFLAGS := $(GO_LDFLAGS) -w\) -s|\1|' -i mk/main.mk ||die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" GOPATH="${WORKDIR}/${P}" emake build
}

src_install() {
	dobin bin/*
	dodoc CHANGELOG.md CONTRIBUTING.md README.md ROADMAP.md
}
