# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
inherit cargo

DESCRIPTION="Audit Cargo.lock for crates with security vulnerabilities"
HOMEPAGE="https://rustsec.org https://github.com/rustsec/rustsec"
SRC_URI="https://github.com/rustsec/rustsec/archive/refs/tags/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/rustsec/releases/download/${PN}%2Fv${PV}/rustsec-${PN}-v${PV}-crates.tar.xz"
S=${WORKDIR}/rustsec-${PN}-v${PV}

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT MPL-2.0
	Unicode-3.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fix"

# requires checkout of vuln db/network
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_configure() {
	local myfeatures=(
		$(usev fix)
	)

	cargo_src_configure
}

src_compile() {
	# normally we can pass --bin cargo-audit
	# to build single workspace member, but we need to cd
	# for tests to be discovered properly
	cd cargo-audit || die
	cargo_src_compile
}

src_install() {
	cargo_src_install --path cargo-audit
	local DOCS=( cargo-audit/{README.md,audit.toml.example} )
	einstalldocs
}
