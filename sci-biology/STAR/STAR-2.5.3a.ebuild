# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="STAR aligner: align RNA-seq reads to reference genome uncompressed suffix arrays"
HOMEPAGE="https://github.com/alexdobin/STAR"
SRC_URI="https://github.com/alexdobin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sci-libs/htslib:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-2.5.3a-fix-build-system.patch )
DOCS=( README.md CHANGES.md RELEASEnotes.md doc/STARmanual.pdf )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_configure() {
	tc-export CC CXX PKG_CONFIG
}

src_compile() {
	emake -C source STAR
}

src_install() {
	dobin source/STAR
	einstalldocs
}
