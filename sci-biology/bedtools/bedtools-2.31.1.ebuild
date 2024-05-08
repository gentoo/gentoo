# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="Tools for manipulation and analysis of BED, GFF/GTF, VCF, SAM/BAM file formats"
HOMEPAGE="https://bedtools.readthedocs.io/"
SRC_URI="https://github.com/arq5x/${PN}2/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/${PN}2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	test? ( >=sci-biology/samtools-1.10:0 )"

# bedtools2 has a *terrible* build system and development practices.
# Upstream has forked htslib 1.9 and extended it by adding clever callbacks
# that make unbundling it nigh impossible. There are no signs of upstream porting
# their fork to 1.10, which means we're stuck with the bundled version.
PATCHES=(
	"${FILESDIR}"/${PN}-2.31.1-buildsystem.patch
	"${FILESDIR}"/${PN}-2.31.1-python.patch
	"${FILESDIR}"/${PN}-2.31.1-includes.patch
)

src_configure() {
	tc-export AR CC CXX RANLIB
}

src_install() {
	default

	insinto /usr/share/bedtools
	doins -r genomes
}
