# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

DESCRIPTION="Simple and flexible tool for managing secrets"
HOMEPAGE="https://getsops.io/ https://github.com/getsops/sops"
SRC_URI="https://github.com/getsops/sops/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MPL-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-lang/go-1.25.8
	test? ( app-crypt/gnupg )
"

src_compile() {
	ego build -o bin/${PN} ./cmd/sops

	einfo "generating shell completion files"
	sysroot_try_run_prefixed bin/${PN} completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed bin/${PN} completion zsh > ${PN}.zsh || die
}

src_test() {
	unset SOPS_AGE_KEY SOPS_AGE_KEY_FILE SOPS_AGE_KEY_CMD SOPS_AGE_RECIPIENT \
		SOPS_AGE_SSH_PRIVATE_KEY_FILE SOPS_AGE_SSH_PRIVATE_KEY_CMD

	local -x GNUPGHOME="${T}/gnupg"
	mkdir -m 700 "${GNUPGHOME}" || die
	gpg --batch --import pgp/sops_functional_tests_key.asc || die

	# hcvault and kms start containers via dockertest
	local pkgs=( $(ego list ./... | grep -Ev '/(hcvault|kms)$') )
	assert

	# Test_releaseFetcher_*: query GitHub for the latest release
	# TestGnuPGHome_Import: expects exact gpg stderr, breaks when gpg
	# warns about insecure memory (no mlock, e.g. in containers)
	nonfatal ego test "${pkgs[@]}" \
		-skip '^(Test_releaseFetcher_|TestGnuPGHome_Import$)'
	local ret=${?}
	gpgconf --kill all
	[[ ${ret} -eq 0 ]] || die "tests failed"
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
}
