# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Next generation command line interface for cilium"
HOMEPAGE="https://cilium.io"
SRC_URI="https://github.com/cilium/cilium-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake VERSION=v${PV}
}

src_test() {
	emake test
}

src_install() {
	dobin cilium
}
