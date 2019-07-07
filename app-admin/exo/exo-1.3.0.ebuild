# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command-line tool for everything at Exoscale: compute, storage, dns."
HOMEPAGE="https://exoscale.github.io/cli"
SRC_URI="https://github.com/exoscale/cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
DEPEND="dev-lang/go:="
RESTRICT="strip"

S="${WORKDIR}/cli-${PV}"

src_compile() {
	go build -mod vendor -o ${PN} || die "build failed"
}

src_install() {
	dobin ${PN}
}
