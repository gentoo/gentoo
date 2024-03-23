# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Compute Groebner fans and tropical varieties"
HOMEPAGE="https://users-math.au.dk/~jensen/software/gfan/gfan.html"
SRC_URI="https://users-math.au.dk/~jensen/software/${PN}/${PN}${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="doc? ( virtual/latex-base )"
DEPEND="dev-libs/gmp:0=[cxx(+)]
	sci-libs/cddlib:0="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.2-xcode9.3_compat.patch"
	"${FILESDIR}/${PN}-0.6.2-testsuite.patch"
	"${FILESDIR}/${PN}-0.6.2-Makefile.patch"
	)

pkg_setup() {
	tc-export CC CXX

	# This should really go in cppflags, but that doesn't work with
	# gfan's hand-written Makefile.
	append-cxxflags -DNOCDDPREFIX -I"${EPREFIX}"/usr/include/cddlib
}

src_prepare() {
	default

	# This test hangs on x86, bug 717112.
	rm -r testsuite/0602ResultantFanProjection || \
		die "unable to disable test 0602ResultantFanProjection"

	# And this one fails (harmlessly) on x86, bug 818397.
	rm -r testsuite/0009RenderStairCase || \
		die "unable to disable test 0009RenderStairCase"
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/863044
	# Only contact method is email. I have sent one detailing the issue.
	filter-lto

	# The upstream Makefile says that GCC produces bad code with -O3.
	replace-flags "-O3" "-O2"
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
