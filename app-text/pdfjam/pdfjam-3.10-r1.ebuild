# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PDFJAM_EXTRAS_COMMIT=622e03add59db004144c0b41722a09b3b29d6d3e

DESCRIPTION="Allows the manipulation of PDF files"
HOMEPAGE="https://github.com/rrthomas/pdfjam"
SRC_URI="
	https://github.com/rrthomas/pdfjam/releases/download/v${PV}/pdfjam-${PV}.tar.gz
	extra? (
		https://github.com/rrthomas/pdfjam-extras/archive/${PDFJAM_EXTRAS_COMMIT}.tar.gz
			-> pdfjam-extra-20191118.tar.gz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

IUSE="extra test"
RESTRICT="!test? ( test )"

DEPEND="virtual/latex-base"
RDEPEND="
	${DEPEND}
	!<dev-texlive/texlive-binextra-2023_p69527-r4
"
BDEPEND="test? ( app-arch/unzip )"

src_prepare() {
	default
	if use test; then
		unzip tests.zip || die
	fi
}

src_test() {
	./tests/run.sh || die
}

src_install() {
	dobin bin/*
	dodoc README.md
	doman man1/*

	insinto usr/share/etc
	doins pdfjam.conf

	if use extra; then
		cd ../pdfjam-extras-${PDFJAM_EXTRAS_COMMIT} || die

		dobin bin/*
		newdoc README.md README-extras.md
		doman man1/*
	fi
}
