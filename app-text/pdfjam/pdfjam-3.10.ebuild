# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PDFJAM_EXTRAS_VERSION="20191118"

DESCRIPTION="Manipulate PDF files via pdfnup, pdfjoin and pdf90"
HOMEPAGE="https://github.com/rrthomas/pdfjam"
SRC_URI="
	https://github.com/rrthomas/pdfjam/releases/download/v${PV}/${PN}-${PV}.tar.gz
	extras? ( https://dev.gentoo.org/~flow/distfiles/pdfjam/pdfjam-extras-${PDFJAM_EXTRAS_VERSION}.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

IUSE="+extras test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-texlive/texlive-latex
	test? (
		app-arch/unzip
	)
"

src_test() {
	unzip tests.zip || die
	./tests/run.sh || die
}

src_install() {
	dobin bin/*
	dodoc pdfjam.conf README.md
	doman man1/*

	if use extras; then
		pushd "../pdfjam-extras-${PDFJAM_EXTRAS_VERSION}" || die
		dobin bin/*
		newdoc README.md README-extras.md
		doman man1/*
	fi
}
