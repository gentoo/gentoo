# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="validate kubernetes YAML or JSON configuration files"
HOMEPAGE="https://kubeval.com"
SRC_URI="https://github.com/instrumenta/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# tests require the network
RESTRICT="test"

src_compile() {
	emake TAG=v${PV} build
}

src_install() {
	dobin bin/kubeval
dodoc -r docs/*
}

src_test() {
	emake TAG=v${PV} test
}
