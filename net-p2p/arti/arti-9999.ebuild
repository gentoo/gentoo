# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

MY_P="${PN}-${PN}-v${PV}"

DESCRIPTION="An implementation of Tor, in Rust."
HOMEPAGE="https://gitlab.torproject.org/tpo/core/arti/"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.torproject.org/tpo/core/arti"
else
	SRC_URI="https://gitlab.torproject.org/tpo/core/${PN}/-/archive/${PN}-v${PV}/${PN}-${PN}-v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT Apache-2.0"
SLOT="0"

DEPEND="app-arch/xz-utils
	dev-db/sqlite:3
	dev-libs/openssl:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/arti"

src_unpack() {
	if [[ "${PV}" == *9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	pushd crates/arti || die
	cargo_src_compile
}

src_test() {
	for crate in crates/*; do
		pushd "${crate}" >/dev/null || die
		cargo_src_test
		popd >/dev/null || die
	done
}

src_install() {
	pushd crates/arti >/dev/null || due

	cargo_src_install
	newdoc src/arti-example-config.toml arti.toml

	popd >/dev/null || die

	dodoc -r doc/*
}
