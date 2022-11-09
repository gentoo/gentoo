# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="haproxy dataplane api / sidecar"
HOMEPAGE="https://github.com/haproxytech/dataplaneapi https://www.haproxy.com/documentation/dataplaneapi/latest/"

SRC_URI="https://github.com/haproxytech/dataplaneapi/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://gentooexperimental.org/~patrick/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/dataplaneapi-${PV}"

src_compile() {
	GOBIN="${S}/bin" emake build
}

src_install() {
	dobin build/dataplaneapi
	dodoc README.md
}
