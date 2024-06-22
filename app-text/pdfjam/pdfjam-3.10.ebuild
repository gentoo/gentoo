# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Allows the manipulation of PDF files (pdfnup, pdfjoin and pdf90)"
HOMEPAGE="https://github.com/rrthomas/pdfjam"
SRC_URI="https://github.com/rrthomas/pdfjam/releases/download/v${PV}/pdfjam-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

IUSE="test"
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
}
