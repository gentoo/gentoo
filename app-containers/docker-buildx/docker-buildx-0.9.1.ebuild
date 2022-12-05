# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PN="buildx"
DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"
SRC_URI="https://github.com/docker/buildx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="app-containers/docker"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	local _buildx_r='github.com/docker/buildx'
	go build -mod=vendor -o docker-buildx \
		-ldflags "-linkmode=external \
		-X $_buildx_r/version.Version=${PV} \
		-X $_buildx_r/version.Revision=$(date -u +%FT%T%z) \
		-X $_buildx_r/version.Package=$_buildx_r" \
		./cmd/buildx || die
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe docker-buildx

	dodoc README.md
}

src_test() {
	go test ./... || die
}
