# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1

inherit toolchain-funcs cargo

DESCRIPTION="Tree-sitter is a parser generator tool and an incremental parsing library"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="
		https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		ts-cli? ( $(cargo_crate_uris) )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="MIT ts-cli? ( Apache-2.0 BSD-2 CC0-1.0 ISC MIT )"
SLOT="0"

IUSE="ts-cli"

BDEPEND="ts-cli? ( virtual/rust )"

PATCHES=(
	"${FILESDIR}/${PN}-No-static-libs-gentoo.patch"
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		use ts-cli && cargo_live_src_unpack
	else
		# behaves as default too, so it is ok to call it unconditonally
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC
}

src_configure() {
	default
	use ts-cli && cargo_src_configure
}

src_compile() {
	default
	use ts-cli && cargo_src_compile
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	use ts-cli && cargo_src_install --path "./cli"
}
