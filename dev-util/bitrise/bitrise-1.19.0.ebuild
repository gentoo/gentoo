# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_ON="github.com/bitrise-io"
EGO_PN="${EGO_ON}/${PN}"

DESCRIPTION="Run your Bitrise.io automations on any Mac or Linux machine"
HOMEPAGE="https://www.bitrise.io/cli"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=dev-util/envman-1.2.0
>=dev-util/stepman-0.10.0"

S="${WORKDIR}/src/${EGO_ON}/${PN}"

src_unpack() {
	unpack ${A}
	mkdir -p "${WORKDIR}/src/${EGO_ON}" || die "Couldn't create project dir in GOPATH"
	mv "${WORKDIR}/${P}" "${WORKDIR}/src/${EGO_ON}/bitrise" || die "Couldn't move sources to GOPATH"
}

src_compile() {
	GOPATH="${WORKDIR}" go build -v -o bin/bitrise || die "Couldn't compile bitrise"
}

src_test() {
	export PULL_REQUEST_ID=""
	export INTEGRATION_TEST_BINARY_PATH="${S}/bin/bitrise"
	GOPATH="${WORKDIR}" go test -v ./_tests/integration/... || die "Integration tests failed"
}

src_install() {
	dobin bin/bitrise
	dodoc README.md
	use doc && dodoc -r _docs
}
