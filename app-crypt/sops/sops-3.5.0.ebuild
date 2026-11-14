# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

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

BDEPEND="test? ( app-crypt/gnupg )"

src_compile() {
	# go.mod declares go 1.13, so vendor/ isn't used without -mod=vendor
	ego build -mod=vendor -o bin/${PN} ./cmd/sops
}

src_test() {
	local -x GNUPGHOME="${T}/gnupg"
	mkdir -m 700 "${GNUPGHOME}" || die
	gpg --batch --import pgp/sops_functional_tests_key.asc || die

	local -x VAULT_ADDR="http://127.0.0.1:8200"

	nonfatal ego test -mod=vendor -vet=off ./... -skip '^TestRetrievePGPKey$'
	local ret=${?}
	gpgconf --kill all
	[[ ${ret} -eq 0 ]] || die "tests failed"
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}
