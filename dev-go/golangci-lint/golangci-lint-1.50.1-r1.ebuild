# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
# update on every bump
GIT_COMMIT=8926a95f

DESCRIPTION="Fast linters runner for Go"
HOMEPAGE="https://github.com/golangci/golangci-lint"
SRC_URI="https://github.com/golangci/golangci-lint/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_compile() {
	CGO_ENABLED=0 ego build -trimpath -ldflags "
		-X main.commit=${GIT_COMMIT}
		-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
		-X main.version=${PV}" \
			-o golangci-lint ./cmd/golangci-lint
}

src_test() {
	emake test
}

src_install() {
	dobin golangci-lint
	einstalldocs
dodoc CHANGELOG.md
}
