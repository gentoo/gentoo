# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Fast linters runner for Go"
HOMEPAGE="https://github.com/golangci/golangci-lint"
SRC_URI="https://github.com/golangci/golangci-lint/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake build
}

src_test() {
	emake test
}

src_install() {
	dobin golangci-lint
}
