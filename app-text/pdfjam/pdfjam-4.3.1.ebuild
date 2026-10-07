# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

PDFJAM_EXTRAS_COMMIT=622e03add59db004144c0b41722a09b3b29d6d3e

DESCRIPTION="Tool for manipulatiing PDF files"
HOMEPAGE="https://github.com/pdfjam/pdfjam"
SRC_URI="
	https://github.com/pdfjam/pdfjam/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	extra? (
		https://github.com/pdfjam/pdfjam-extras/archive/${PDFJAM_EXTRAS_COMMIT}.tar.gz
			-> pdfjam-extra-20191118.tar.gz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

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
BDEPEND="
	dev-tex/latexmk
	test? (
		app-shells/bash
		app-shells/ksh
		app-shells/zsh
		app-text/texlive[xetex]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	!<dev-texlive/texlive-binextra-2023_p69527-r4
"

src_prepare() {
	default

	sed -i \
		-e s/ghostscript/gs/ \
		-e 's/latexmk/latexmk -pdf/g' \
		utils/build.sh || die

	if use test; then
		local real_s=$(realpath "${S}")
		local built_pdfjam="${real_s}/build/unpacked/pdfjam"
		# Inject the absolute path to bypass environment clearing and sandbox isolation.
		# Applied to root orchestrators to fix the execution call:
		sed -i "s|\./pdfjam|${built_pdfjam}|g" check-tex.lua build.lua || die
		# Applied to testfiles to ensure the expected log diffs (.tlg) match the new call:
		find testfiles -type f -exec sed -i "s|\./pdfjam|${built_pdfjam}|g" {} + || die
		sed -i -E "s@(^|[[:space:]])(\.\./)*pdfjam([[:space:]]|$)@\1${built_pdfjam}\3@g" \
			testfiles/defaults.sh testfiles/papersizes.sh || die
	fi

	echo "${PV}" > doc/version.tex || die
}

src_compile() {
	local -x MINIMAL_BUILD=2
	./utils/build.sh ${PV} || die
}

src_test() {
	:
	#l3build check || die

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
