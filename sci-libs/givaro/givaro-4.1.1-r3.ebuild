# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ library for arithmetic and algebraic computations"
HOMEPAGE="https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
SRC_URI="https://github.com/linbox-team/givaro/releases/download/v${PV}/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0/9"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2 doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"
DEPEND="dev-libs/gmp:0[cxx(+)]"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/givaro-4.1.1-gcc-10.patch"
	"${FILESDIR}/givaro-4.1.1-fix-pc-libdir.patch"
)

src_configure() {
	# Passing "--disable-doc" also accidentally enables building
	# the documentation, so we can't just $(use_enable doc) here.
	# https://github.com/linbox-team/givaro/issues/148
	econf \
		$(usex doc --enable-doc "" "" "") \
		--with-docdir="/usr/share/doc/${PF}/html" \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_fma3 fma) \
		$(use_enable cpu_flags_x86_fma4 fma4) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41) \
		$(use_enable cpu_flags_x86_sse4_2 sse42) \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable cpu_flags_x86_avx2 avx2)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
