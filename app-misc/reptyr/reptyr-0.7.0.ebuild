# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 toolchain-funcs flag-o-matic vcs-snapshot

DESCRIPTION="A utility to attach a running program to a new terminal"
HOMEPAGE="https://github.com/nelhage/reptyr"
SRC_URI="https://github.com/nelhage/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RESTRICT="test"

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
	newbashcomp reptyr{.bash,}
}
