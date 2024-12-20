# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module shell-completion
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="The command line for influxdb"
HOMEPAGE="https://github.com/influxdata/influx-cli"

SRC_URI="https://github.com/influxdata/influx-cli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://gentoo.kropotkin.rocks/go-pkgs/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Previous versions ship they own client
DEPEND="!<dev-db/influxdb-2.0.0"
RDEPEND="${DEPEND}"

src_compile() {
	unset LDFLAGS
	emake

	cd bin/$(go env GOOS)/$(go env GOARCH)/ || die
	./influx completion bash > influx-completion.bash || die
	./influx completion zsh > influx-completion.zsh || die
}

src_install() {
	cd bin/$(go env GOOS)/$(go env GOARCH) || die

	dobin influx

	newbashcomp influx-completion.bash influx
	newzshcomp influx-completion.zsh _influx
}

src_test() {
	emake test
}
