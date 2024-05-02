# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Command-line tool for everything at Exoscale: compute, storage, dns"
HOMEPAGE="https://github.com/exoscale/cli"
SRC_URI="https://github.com/exoscale/cli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/cli-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.16:="
RESTRICT="strip"

src_compile() {
	ego build -mod vendor -o ${PN} -ldflags "-X main.version=${PVR}-gentoo -X main.commit="
}

src_test() {
	# run at least 'exo version' for test
	./exo version > /dev/null 2>&1
	if [[ $? -ne 0 ]]
	then
		die "Test failed"
	fi
}

src_install() {
	dobin ${PN}
}
