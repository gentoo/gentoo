# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-src.zip"

LICENSE="Artistic"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~x64-macos"

IUSE="examples +tbb"

RDEPEND="tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	sci-biology/seqan:1.4
	app-arch/unzip"

DOCS=( AUTHORS NEWS TUTORIAL doc/README )
HTML_DOCS=( doc/{manual.html,style.css} )

PATCHES=(
	"${FILESDIR}/${P}-_ContextLss-1.1-1.4.patch"
	"${FILESDIR}/${P}-fix-setBegin-call.patch"
	"${FILESDIR}/${P}-seqan-popcount.patch"
	"${FILESDIR}/${P}-seqan-rename-ChunkPool.patch"
	"${FILESDIR}/${P}-seqan-rename-fill-to-resize.patch"
	"${FILESDIR}/${P}-spelling.patch"
	"${FILESDIR}/${P}-tbb-tinythread-missing.patch"
	"${FILESDIR}/${P}-unbundle-seqan.patch"
)

src_prepare() {
	default

	# remove bundled libraries, use system seqan 1.4
	rm -rf SeqAn-1.1/ third_party/ || die

	# innocuous non-security flags, prevent log pollution
	append-cxxflags \
		-Wno-unused-local-typedefs \
		-Wno-unused-but-set-variable \
		-Wno-unused-variable
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CFLAGS="" \
		CXXFLAGS="" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}" \
		WITH_TBB="$(usex tbb 1 0)"
}

src_install() {
	dobin ${PN} ${PN}-*

	exeinto /usr/libexec/${PN}
	doexe scripts/*

	newman MANUAL ${PN}.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}
		doins -r genomes indexes
	fi
}
