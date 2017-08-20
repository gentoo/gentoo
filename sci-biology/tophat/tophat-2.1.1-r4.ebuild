# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Python-based splice junction mapper for RNA-Seq reads using bowtie2"
HOMEPAGE="https://ccb.jhu.edu/software/tophat/"
SRC_URI="https://ccb.jhu.edu/software/tophat/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=[threads]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	sci-biology/samtools:0.1-legacy
	sci-biology/bowtie:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sci-biology/seqan:1.4
	>=sys-devel/autoconf-archive-2016.09.16"

PATCHES=(
	"${FILESDIR}"/${P}-unbundle-seqan-samtools.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-python2-shebangs.patch
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
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags seqan-1.4)"

	# remove ancient autoconf archive macros, wreaking havoc,
	# depend on sys-devel/autoconf-archive instead, bug #594810
	rm {ax_boost_thread,ax_boost_base}.m4 || die

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default

	# delete bundled python modules
	local i
	for i in intervaltree sortedcontainers; do
		rm -r "${ED%/}"/usr/bin/${i} || die
	done
}

pkg_postinst() {
	optfeature "ABI SOLiD colorspace reads" sci-biology/bowtie:1
}
