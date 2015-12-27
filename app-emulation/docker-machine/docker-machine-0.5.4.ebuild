# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN=github.com/docker/machine/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Machine management for a container-centric world"
HOMEPAGE="https://docs.docker.com/machine/ "
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=">=dev-lang/go-1.5:="
RDEPEND=""
S=${WORKDIR}/${P}/src/${EGO_PN%/*}

src_prepare() {
	# don't pre-strip binaries
	sed -e 's|\(GO_LDFLAGS := $(GO_LDFLAGS) -w\) -s|\1|' -i mk/main.mk ||die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake build || die
}

src_install() {
	dobin bin/*
	dodoc CHANGELOG.md CONTRIBUTING.md README.md ROADMAP.md
}
