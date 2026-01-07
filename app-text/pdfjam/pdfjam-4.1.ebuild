# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

PDFJAM_EXTRAS_COMMIT=622e03add59db004144c0b41722a09b3b29d6d3e

DESCRIPTION="Tool for manipulatiing PDF files"
HOMEPAGE="https://github.com/rrthomas/pdfjam"
SRC_URI="
	https://github.com/pdfjam/pdfjam/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	extra? (
		https://github.com/rrthomas/pdfjam-extras/archive/${PDFJAM_EXTRAS_COMMIT}.tar.gz
			-> pdfjam-extra-20191118.tar.gz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

IUSE="extra test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	virtual/latex-base
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		app-text/texlive[xetex]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	!<dev-texlive/texlive-binextra-2023_p69527-r4
"

src_prepare() {
	default

	sed -i s/mandate=.*/mandate=2025-01-31/ utils/build.sh || die
}

src_compile() {
	./utils/build.sh ${PV} || die
}

src_test() {
	l3build check || die

	# XXX: this seems to run a different set of tests than "l3build
	# check", but the tests run by check-tex.sh fail (bug #950103).
	# ./utils/check-tex.sh || die
}

src_install() {
	cd build/pdfjam || die

	dobin bin/*
	dodoc README.md
	doman man/*

	insinto usr/share/etc
	doins pdfjam.conf

	dozshcomp shell-completion/zsh/_pdfjam

	if use extra; then
		cd "${WORKDIR}"/pdfjam-extras-${PDFJAM_EXTRAS_COMMIT} || die

		dobin bin/*
		newdoc README.md README-extras.md
		doman man1/*
	fi
}
