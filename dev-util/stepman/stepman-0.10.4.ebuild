# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

EGO_ON="github.com/bitrise-io"
EGO_PN="${EGO_ON}/${PN}"

DESCRIPTION="Step collection manager for Bitrise CLI"
HOMEPAGE="https://www.bitrise.io/cli"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/src/${EGO_ON}/${PN}"

src_unpack() {
	default
	mkdir -p "${WORKDIR}/src/${EGO_ON}" || die "Couldn't create project dir in GOPATH"
	mv "${WORKDIR}/${P}" "${WORKDIR}/src/${EGO_ON}/stepman" || die "Couldn't move sources to GOPATH"
}

src_compile() {
	GOPATH="${WORKDIR}" go build -v -o bin/stepman || die "Couldn't compile stepman"
}

src_test() {
	pushd _tests/integration > /dev/null || die "Couldn't find integration tests directory"
	rm update_test.go step_info_test.go setup_test.go || die "Couldn't remove network-dependent tests"
	popd || die "Couldn't return to ${S} directory"
	local -x INTEGRATION_TEST_BINARY_PATH="${S}/bin/stepman"
	GOPATH="${WORKDIR}" go test -v ./_tests/integration/... || die "Integration tests failed"
}

src_install() {
	dobin bin/stepman
	dodoc README.md
}
