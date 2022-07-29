# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_COMMIT=ba9adb17ebb510a2a3bd2b641738b1d9235e1f3e

DESCRIPTION="Generate a Software Bill of Materials from container images and filesystems"
HOMEPAGE="https://www.anchore.com"
SRC_URI="https://github.com/anchore/syft/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# tests require a running docker daemon
RESTRICT="test"

src_compile() {
	local BUILD_DATE
	BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
	ego build -o bin/syft -ldflags "
		-X github.com/anchore/syft/internal/version.version=${PV}
		-X github.com/anchore/syft/internal/version.gitCommit=${GIT_COMMIT}
			-X github.com/anchore/syft/internal/version.buildDate=${BUILD_DATE}
			-X github.com/anchore/syft/internal/version.gitDescription=v${PV}
		" ./cmd/syft
}

src_install() {
	dobin bin/*
}
