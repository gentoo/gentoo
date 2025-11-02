# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo go-module

DESCRIPTION="A utility to convert markdown to man pages"
HOMEPAGE="https://github.com/cpuguy83/go-md2man"
SRC_URI="https://github.com/cpuguy83/go-md2man/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/dev-go/${PN}/${P}-deps.tar.xz"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

src_compile() {
	emake build
}

src_test() {
	emake test
}

src_install() {
	dobin bin/go-md2man

	edo "${S}"/bin/go-md2man -in go-md2man.1.md -out go-md2man.1
	doman go-md2man.1
}
