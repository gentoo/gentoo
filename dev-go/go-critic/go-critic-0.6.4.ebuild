# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="The most opinionated Go source code linter for code audit"
HOMEPAGE="https://github.com/go-critic/go-critic"
SRC_URI="https://github.com/go-critic/go-critic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests fail
RESTRICT="test"

src_compile() {
	emake GOCRITIC_VERSION=v${PV} build-release
}

src_install() {
	dobin bin/*
}
