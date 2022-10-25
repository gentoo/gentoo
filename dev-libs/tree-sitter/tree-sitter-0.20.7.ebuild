# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit optfeature toolchain-funcs

DESCRIPTION="Tree-sitter is a parser generator tool and an incremental parsing library"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
fi

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-No-static-libs-gentoo.patch" )

# see Makefile:1
QA_PKGCONFIG_VERSION="0.6.3"

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" \
		  PREFIX="${EPREFIX}/usr" \
		  LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		  install
}

pkg_postinst() {
	optfeature "building and testing grammars" dev-util/tree-sitter-cli
}
