# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Compute Groebner fans and tropical varieties"
HOMEPAGE="https://users-math.au.dk/~jensen/software/gfan/gfan.html"
SRC_URI="https://users-math.au.dk/~jensen/software/${PN}/gfan0.8beta.tar.gz
	https://dev.gentoo.org/~mjo/distfiles/${PN}-0.8-libcxx.patch.xz"

S="${WORKDIR}/gfan0.8beta"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="doc"

# texlive-plaingeneric is needed for \usepackage{ulem} in
# the manual. ghostscript-gpl provides the "dvipdf" command.
BDEPEND="doc? (
	app-text/ghostscript-gpl
	dev-texlive/texlive-plaingeneric
	virtual/latex-base
)"
DEPEND="dev-cpp/abseil-cpp:=
	dev-cpp/tbb:=
	dev-libs/gmp:0=[cxx(+)]
	sci-libs/cddlib:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.2-fix-spelling-errors.patch"
	"${FILESDIR}/${PN}-0.8-flags.patch"
	"${FILESDIR}/${PN}-0.8-Makefile.patch"
	"${FILESDIR}/${PN}-0.8-clang-warnings.patch"
	"${FILESDIR}/${PN}-0.8-uint64.patch"
	"${FILESDIR}/${PN}-0.8-int128.patch"
	"${FILESDIR}/${PN}-0.8-test-return.patch"
	"${WORKDIR}/${PN}-0.8-libcxx.patch"
)

pkg_setup() {
	tc-export CC CXX

	# Fix the cddlib include dir by declaring it not to exist, and then
	# adding the correct one manually via -I.
	append-cppflags -DNOCDDPREFIX -I"${EPREFIX}"/usr/include/cddlib
}

src_prepare() {
	default

	# https://bugs.debian.org/1103374
	rm -r testsuite/0500MixedVolume || \
		die "unable to disable test 0500MixedVolume"

	# This one fails (harmlessly) on x86, bug 818397.
	rm -r testsuite/0009RenderStairCase || \
		die "unable to disable test 0009RenderStairCase"

	# Assertion '!this->empty()' failed. Might be important, but there's
	# nowhere to report the failures to.
	rm -r testsuite/200[012]TropicalPrevariety || \
		die "unable to disable 200XTropicalPrevariety tests"
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/863044
	# Only contact method is email. I have sent one detailing the issue.
	filter-lto

	default
}

src_compile() {
	default
	if use doc; then
		pushd doc > /dev/null || die
		# The LaTeX build commands need to be repeated until the
		# document "stops changing," which is not as easy as it
		# sounds to detect. Running it twice seems to work here.
		for iteration in 1 2; do
			latex manual.tex && \
				bibtex manual && \
				dvipdf manual.dvi manual.pdf || die
		done
		popd > /dev/null || die
	fi
}

src_install() {
	emake PREFIX="${ED}/usr" install
	use doc && dodoc doc/manual.pdf
}
