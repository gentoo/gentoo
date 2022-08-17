# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_COMMIT=a6ec8f11be5fdc116dc7bbfebdc03bfc13cd2005
SYFT_VERSION=0.52.0

DESCRIPTION="A vulnerability scanner for container images and filesystems"
HOMEPAGE="https://www.anchore.com"
SRC_URI="https://github.com/anchore/grype/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# tests require a running docker
RESTRICT="test"

src_compile() {
	ego build -o bin/grype -ldflags "
		-extldflags '-static'
		-X github.com/anchore/grype/internal/version.version=${PV}
		-X github.com/anchore/grype/internal/version.syftVersion=${SYFT_VERSION}
		-X github.com/anchore/grype/internal/version.gitCommit=${GIT_COMMIT}
			-X github.com/anchore/grype/internal/version.buildDate=${BUILD_DATE}
			-X github.com/anchore/grype/internal/version.gitDescription=v${PV}"
}

src_install() {
	dobin bin/grype
}
