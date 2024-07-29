# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="The command line for influxdb"
HOMEPAGE="https://github.com/influxdata/influx-cli"

SRC_URI="https://github.com/influxdata/influx-cli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT=" test"

src_compile() {
	unset LDFLAGS
	emake
}

src_install() {
	dobin bin/$(go env GOOS)/$(go env GOARCH)/influx
}
