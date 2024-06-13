# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 9999* ]] || CRATES="${PN}@${PV}"

inherit cargo systemd

DESCRIPTION="A container network stack"
HOMEPAGE="https://github.com/containers/netavark"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/netavark.git"
else
	SRC_URI="${CARGO_CRATE_URIS} https://github.com/containers/netavark/releases/download/v${PV}/${PN}-v${PV}-vendor.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv"
fi

# main
LICENSE="Apache-2.0"
# deps
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
BDEPEND="dev-go/go-md2man
	dev-libs/protobuf"

QA_FLAGS_IGNORED="
	usr/libexec/podman/${PN}"
QA_PRESTRIPPED="
	usr/libexec/podman/${PN}"

ECARGO_VENDOR="${WORKDIR}/vendor"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	sed -i -e "s|m0755 bin|m0755 $(cargo_target_dir)|g;" Makefile || die
}

src_compile() {
	cargo_src_compile
	export PREFIX="${EPREFIX}"/usr SYSTEMDDIR="$(systemd_get_systemunitdir)"
	emake docs
}

# Following is needed because we want to use `make install` instead of `cargo install` (exported by cargo.eclass)
src_install() {
	default
}
