# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils eutils python-any-r1
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/doxygen/doxygen.git"
	SRC_URI=""
else
	SRC_URI="http://doxygen.nl/files/${P}.src.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Documentation system for most programming languages"
HOMEPAGE="http://www.doxygen.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="clang debug doc dot doxysearch latex qt5 sqlite userland_GNU"

RDEPEND="app-text/ghostscript-gpl
	dev-lang/perl
	media-libs/libpng:0=
	virtual/libiconv
	clang? ( >=sys-devel/clang-4.0.0:= )
	dot? (
		media-gfx/graphviz
		media-libs/freetype
	)
	doxysearch? ( dev-libs/xapian:= )
	latex? (
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	sqlite? ( dev-db/sqlite:3 )
	"

REQUIRED_USE="doc? ( latex )"

DEPEND="sys-devel/flex
	sys-devel/bison
	doc? ( ${PYTHON_DEPS} )
	${RDEPEND}"

# src_test() defaults to make -C testing but there is no such directory (bug #504448)
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.9.1-empty-line-sigsegv.patch" #454348
	"${FILESDIR}/${PN}-1.8.15-link_with_pthread.patch"
	"${FILESDIR}/${PN}-1.8.15-llvm7.patch" #666692
	"${FILESDIR}/${PN}-1.8.14-xml-c++.patch" #doxygen/doxygen#6892
)

DOCS=( LANGUAGE.HOWTO README.md )

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# Ensure we link to -liconv
	if use elibc_FreeBSD && has_version dev-libs/libiconv || use elibc_uclibc; then
		local pro
		for pro in */*.pro.in */*/*.pro.in; do
			echo "unix:LIBS += -liconv" >> "${pro}" || die
		done
	fi

	# Call dot with -Teps instead of -Tps for EPS generation - bug #282150
	sed -i -e '/addJob("ps"/ s/"ps"/"eps"/g' src/dot.cpp || die

	# fix pdf doc
	sed -i.orig -e "s:g_kowal:g kowal:" \
		doc/maintainers.txt || die

	if is-flagq "-O3" ; then
		ewarn
		ewarn "Compiling with -O3 is known to produce incorrectly"
		ewarn "optimized code which breaks doxygen."
		ewarn
		elog
		elog "Continuing with -O2 instead ..."
		elog
		replace-flags "-O3" "-O2"
	fi
}

src_configure() {
	local mycmakeargs=(
		-Duse_libclang=$(usex clang)
		-Dbuild_doc=$(usex doc)
		-Dbuild_search=$(usex doxysearch)
		-Dbuild_wizard=$(usex qt5)
		-Duse_sqlite3=$(usex sqlite)
		)
	use doc && mycmakeargs+=(
		-DDOC_INSTALL_DIR="share/doc/${P}"
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		export VARTEXFONTS="${T}/fonts" # bug #564944

		if ! use dot; then
			sed -i -e "s/HAVE_DOT               = YES/HAVE_DOT    = NO/" \
				{Doxyfile,doc/Doxyfile} \
				|| die "disabling dot failed"
		fi
		cmake-utils_src_make -C "${BUILD_DIR}" docs
	fi
}

src_install() {
	cmake-utils_src_install
}
