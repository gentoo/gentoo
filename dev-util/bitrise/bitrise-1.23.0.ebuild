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

RDEPEND=">=dev-util/envman-2.1.0
	>=dev-util/stepman-0.10.4"

S="${WORKDIR}/src/${EGO_ON}/${PN}"

src_unpack() {
	default
	mkdir -p "${WORKDIR}/src/${EGO_ON}" || die "Couldn't create project dir in GOPATH"
	mv "${WORKDIR}/${P}" "${WORKDIR}/src/${EGO_ON}/bitrise" || die "Couldn't move sources to GOPATH"
}

src_compile() {
	GOPATH="${WORKDIR}" go build -v -o bin/bitrise || die "Couldn't compile bitrise"
}

src_test() {
	pushd _tests/integration > /dev/null || die "Couldn't find integration tests directory"
	rm envstore_test.go exit_code_test.go global_flag_test.go json_params_test.go log_filter_test.go output_alias_test.go \
		step_template_test.go trigger_params_test.go update_test.go timeout_test.go || die "Couldn't remove network-dependent tests"
	popd || die "Couldn't return to ${S} directory"
	local -x PULL_REQUEST_ID=""
	local -x INTEGRATION_TEST_BINARY_PATH="${S}/bin/bitrise"
	GOPATH="${WORKDIR}" go test -v ./_tests/integration/... || die "Integration tests failed"
}

src_install() {
	dobin bin/bitrise
	dodoc README.md
	use doc && dodoc -r _docs
}
