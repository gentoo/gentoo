# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit cmake flag-o-matic llvm-r1 python-any-r1

DESCRIPTION="Documentation system for most programming languages"
HOMEPAGE="https://www.doxygen.nl/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/doxygen/doxygen.git"
else
	SRC_URI="https://doxygen.nl/files/${P}.src.tar.gz"
	SRC_URI+=" https://downloads.sourceforge.net/doxygen/rel-${PV}/${P}.src.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

# GPL-2 also for bundled libmscgen
LICENSE="GPL-2"
SLOT="0"
IUSE="clang debug doc dot doxysearch gui test"
# - We need TeX for tests, bug #765472
# - We keep the odd construct of noop USE=test because of
#   the special relationship b/t RESTRICT & USE for tests.
#   Also, it's a hint which avoids tests being silently skipped during arch testing.
REQUIRED_USE="test? ( doc )"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	${PYTHON_DEPS}
"
RDEPEND="
	app-text/ghostscript-gpl
	dev-db/sqlite:3
	dev-lang/perl
	dev-libs/libfmt:=
	dev-libs/spdlog:=
	virtual/libiconv
	clang? (
		$(llvm_gen_dep '
			sys-devel/clang:${LLVM_SLOT}=
			sys-devel/llvm:${LLVM_SLOT}=
		')
	)
	dot? (
		media-gfx/graphviz[freetype(+)]
	)
	doc? (
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
	)
	doxysearch? ( dev-libs/xapian:= )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.9.4-link_with_pthread.patch"
	"${FILESDIR}/${PN}-1.9.8-suppress-unused-option-libcxx.patch"
	"${FILESDIR}/${PN}-1.12.0-libfmt-11.patch"

	# Backports
	"${FILESDIR}/${PN}-1.12.0-clang-19.patch"
)

DOCS=( LANGUAGE.HOWTO README.md )

pkg_setup() {
	use clang && llvm-r1_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# Call dot with -Teps instead of -Tps for EPS generation - bug #282150
	sed -i -e '/addJob("ps"/ s/"ps"/"eps"/g' src/dot.cpp || die

	# fix pdf doc
	sed -i.orig -e "s:g_kowal:g kowal:" \
		doc/maintainers.txt || die

	if is-flagq "-O3" ; then
		# TODO: Investigate this and report a bug accordingly...
		ewarn "Compiling with -O3 is known to produce incorrectly"
		ewarn "optimized code which breaks doxygen. Using -O2 instead."
		replace-flags "-O3" "-O2"
	fi
}

src_configure() {
	# Very slow to compile, bug #920092
	filter-flags -fipa-pta
	# -Wodr warnings, see bug #854357 and https://github.com/doxygen/doxygen/issues/9287
	filter-lto

	local mycmakeargs=(
		-Duse_libclang=$(usex clang)
		# Let the user choose instead, see also bug #822615
		-Duse_libc++=OFF
		-Dbuild_doc=$(usex doc)
		-Dbuild_search=$(usex doxysearch)
		-Dbuild_wizard=$(usex gui)
		-Duse_sys_spdlog=ON
		-Duse_sys_sqlite3=ON
		-DBUILD_SHARED_LIBS=OFF
		-DGIT_EXECUTABLE="false"

		# Noisy and irrelevant downstream
		-Wno-dev
	)

	use doc && mycmakeargs+=(
		-DDOC_INSTALL_DIR="share/doc/${P}"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		export VARTEXFONTS="${T}/fonts" # bug #564944

		if ! use dot; then
			sed -i -e "s/HAVE_DOT               = YES/HAVE_DOT    = NO/" \
				{testing/Doxyfile,doc/Doxyfile} \
				|| die "disabling dot failed"
		fi

		# -j1 for bug #770070
		cmake_src_compile docs -j1
	fi
}

src_install() {
	cmake_src_install

	# manpages are only automatically installed when docs are
	# https://github.com/doxygen/doxygen/pull/10647
	doman doc/doxygen.1
	use gui && doman doc/doxywizard.1
	use doxysearch && {
		doman doc/doxyindexer.1
		doman doc/doxysearch.1
	}
}
