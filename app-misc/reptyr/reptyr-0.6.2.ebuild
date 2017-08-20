# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic vcs-snapshot

DESCRIPTION="A utility to attach a running program to a new terminal"
HOMEPAGE="https://github.com/nelhage/reptyr"
SRC_URI="https://github.com/nelhage/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

RESTRICT="test"

# https://github.com/nelhage/reptyr/issues/81
SRC_URI+=" https://github.com/nelhage/reptyr/commit/b45fd9238958fcf2d8f3d6fc23e6d491febea2ac.patch -> ${PN}-0.6.2-sysmacros.patch"

PATCHES=(
	"${DISTDIR}/${P}-sysmacros.patch" #581974
)

src_prepare() {
	default
	# respect CFLAGS
	sed -i '/^override/d' Makefile || die
}

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc ChangeLog NOTES README.md
}
