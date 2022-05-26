# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Fast inference of approximately-maximum-likelihood phylogenetic trees"
HOMEPAGE="http://www.microbesonline.org/fasttree/"
SRC_URI="
	http://www.microbesonline.org/fasttree/FastTree-${PV}.c
	http://www.microbesonline.org/fasttree/FastTreeUPGMA.c -> FastTreeUPGMA-${PV}.c
	http://www.microbesonline.org/fasttree/MOTreeComparison.tar.gz -> MOTreeComparison-${PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision openmp cpu_flags_x86_sse3"

REQUIRED_USE="?? ( double-precision cpu_flags_x86_sse3 )"

DOCS=( README )

PATCHES=( "${FILESDIR}"/${P}-format-security.patch )

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack ${A}
	cp "${DISTDIR}"/{FastTreeUPGMA-${PV}.c,FastTree-${PV}.c} . || die
	cp "${FILESDIR}"/CMakeLists.txt . || die
}

src_configure() {
	local mycmakeargs=(
		-DVERSION="${PV}"
		-DHAS_SSE3=$(usex cpu_flags_x86_sse3)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_DOUBLE=$(usex double-precision)
	)
	cmake_src_configure
}
