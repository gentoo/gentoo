# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/moby/libnetwork
GIT_COMMIT=f6ccccb1c082a432c2a5814aaedaca56af33d9ea
inherit golang-vcs-snapshot

DESCRIPTION="Docker container networking"
HOMEPAGE="https://github.com/docker/libnetwork"
SRC_URI="https://github.com/moby/libnetwork/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv ~x86"

S=${WORKDIR}/${P}/src/${EGO_PN}

# needs dockerd
RESTRICT="strip test"

src_compile() {
	GO111MODULE=auto GOPATH="${WORKDIR}/${P}" \
		go build -o "bin/docker-proxy" ./cmd/proxy || die
}

src_install() {
	dobin bin/docker-proxy
	dodoc README.md CHANGELOG.md
}
