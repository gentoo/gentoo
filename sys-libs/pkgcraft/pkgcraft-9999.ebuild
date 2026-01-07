# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.90.0"

inherit cargo edo

DESCRIPTION="C library for pkgcraft"
HOMEPAGE="https://pkgcraft.github.io/"

MY_PN=${PN}-c
MY_P=${MY_PN}-${PV}

if [[ ${PV} == 9999 ]] ; then
	SCALLOP_VERSION="9999"
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3
	S="${WORKDIR}"/${P}/crates/${MY_PN}
else
	# For releases, SCALLOP_VERSION must match the value of PACKAGE_VERSION in
	# the vendored library's configure script.
	#
	# To get the value from the repo use the following command:
	# sed -rn "/^PACKAGE_VERSION=/ s/^.*='(.*)'/\1/p" **/scallop/bash/configure
	SCALLOP_VERSION="5.3.9.20251212"
	SRC_URI="https://github.com/pkgcraft/pkgcraft/releases/download/${MY_P}/${MY_P}.tar.xz"
	S="${WORKDIR}"/${MY_P}
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
# dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0/${PV}"

# Strict dependency versioning is required since the system library must match
# the vendored copy as scallop exports many parts of bash that aren't meant to
# be a public interface and compatibility is not guaranteed between releases.
RDEPEND="~sys-libs/scallop-${SCALLOP_VERSION}"
DEPEND="${RDEPEND}"
# clang needed by bindgen to generate bash bindings
BDEPEND="
	dev-util/cargo-c
	llvm-core/clang
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/lib.*/libpkgcraft.so.*"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	# use system scallop library
	export SCALLOP_NO_VENDOR=1

	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		$(usev !debug '--release')
	)

	edo cargo cbuild "${cargoargs[@]}"
}

src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
		$(usev !debug '--release')
	)

	edo cargo cinstall "${cargoargs[@]}"
}
