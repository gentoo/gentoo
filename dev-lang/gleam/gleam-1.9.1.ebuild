# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo optfeature

DESCRIPTION="A friendly language for building type-safe, scalable systems!"
HOMEPAGE="https://gleam.run https://github.com/gleam-lang/gleam"
SRC_URI="
	https://github.com/gleam-lang/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		${P}-crates.tar.xz
	"
fi

LICENSE+="
Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 MPL-2.0 Unicode-3.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/erlang:*"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	dodoc CHANGELOG.md
	cargo_src_install --path gleam-bin
}

pkg_postinst() {
	optfeature "erlang package support" dev-util/rebar:3
	optfeature "javascript runtime" net-libs/nodejs
}
