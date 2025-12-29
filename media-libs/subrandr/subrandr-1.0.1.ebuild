# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.85.0
inherit cargo edo

DESCRIPTION="Subtitle rendering library for rendering non-ASS subtitles"
HOMEPAGE="https://github.com/afishhh/subrandr/"
SRC_URI="
	https://github.com/afishhh/subrandr/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"

LICENSE="MPL-2.0"
LICENSE+=" MIT Unicode-3.0 Unicode-DFS-2016 ZLIB" # crates
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/lib.*/lib${PN}.*"

src_compile() {
	# xtask is bundled builder aliased in .cargo/config.toml, note that
	# it lacks its own test handler causing `cargo test` to rebuild
	edo cargo xtask build --verbose
}

src_install() {
	local xtaskargs=(
		# destdir currently expects the prefix to be included
		--destdir="${ED}"/usr
		--prefix="${EPREFIX}"/usr
		--libdir="$(get_libdir)"
		--verbose
	)

	edo cargo xtask install "${xtaskargs[@]}"
}
