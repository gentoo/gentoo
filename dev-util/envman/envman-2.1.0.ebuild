# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_ON="github.com/bitrise-io"
EGO_PN="${EGO_ON}/${PN}"

DESCRIPTION="Environment variable manager for Bitrise CLI"
HOMEPAGE="https://www.bitrise.io/cli"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/src/${EGO_ON}/${PN}"

src_unpack() {
	default
	mkdir -p "${WORKDIR}/src/${EGO_ON}" || die "Couldn't create project dir in GOPATH"
	mv "${WORKDIR}/${P}" "${WORKDIR}/src/${EGO_ON}/envman" || die "Couldn't move sources to GOPATH"
}

src_compile() {
	GOPATH="${WORKDIR}" go build -v -o bin/envman || die "Couldn't compile envman"
}

src_test() {
	GOPATH="${WORKDIR}" go test ./... || die "Tests failed"
}

src_install() {
	dobin bin/envman
	einstalldocs
}
