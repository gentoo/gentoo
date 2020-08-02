# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone-cli"

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Command-line interface for Drone"
HOMEPAGE="https://github.com/drone/drone-cli"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}"\
		go install -ldflags "-X main.version=${PV}" ${EGO_PN}/drone || die
	popd || die
}

src_install() {
	dobin bin/drone
	dodoc src/${EGO_PN}/README.md
}
