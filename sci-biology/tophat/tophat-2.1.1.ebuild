# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic python-single-r1

DESCRIPTION="Python-based splice junction mapper for RNA-Seq reads using bowtie2"
HOMEPAGE="https://ccb.jhu.edu/software/tophat/"
SRC_URI="https://ccb.jhu.edu/software/tophat/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/boost
	sci-biology/samtools:0.1-legacy
	sci-biology/bowtie:2"
DEPEND="${RDEPEND}
	sci-biology/seqan:1.4"

PATCHES=(
	"${FILESDIR}/${P}-unbundle-seqan-samtools.patch"
)

src_prepare() {
	default

	# remove bundled libs
	rm -rf src/samtools-0.1.18/ src/SeqAn-1.4.2/ || die

	sed -e "s:samtools_0.1.18:${EPREFIX}/usr/bin/samtools-0.1-legacy/samtools:" \
		-i src/tophat.py src/common.cpp || die

	sed -e "s:/usr/include/bam-0.1-legacy/:${EPREFIX}/usr/include/bam-0.1-legacy/:" \
		-e '/^samtools-0\.1\.18\//d' \
		-e '/^SeqAn-1\.4\.2\//d' \
		-e 's:sortedcontainers/sortedset.py \\:sortedcontainers/sortedset.py:' \
		-e 's:\$(top_builddir)\/src\/::' \
		-i src/Makefile.am || die
	sed -e 's:\$(top_builddir)\/src\/::' -i src/Makefile.am || die

	# innocuous non-security flags, prevent log pollution
	append-cflags -Wno-unused-but-set-variable -Wno-unused-variable
	append-cppflags "$(pkg-config --cflags seqan-1.4)"

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default

	local i
	for i in bed_to_juncs contig_to_chr_coords sra_to_solid tophat tophat-fusion-post; do
		python_fix_shebang "${ED}"/usr/bin/${i}
	done
}

pkg_postinst() {
	optfeature "ABI SOLiD colorspace reads" sci-biology/bowtie:1
}
