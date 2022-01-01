# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils eutils flag-o-matic python-any-r1
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/doxygen/doxygen.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://doxygen.nl/files/${P}.src.tar.gz"
fi

DESCRIPTION="Documentation system for most programming languages"
HOMEPAGE="http://www.doxygen.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="clang debug doc dot doxysearch qt5 sqlite userland_GNU"

RDEPEND="app-text/ghostscript-gpl
	dev-lang/perl
	media-libs/libpng:0=
	virtual/libiconv
	clang? ( >=sys-devel/clang-10:= )
	dot? (
		media-gfx/graphviz
		media-libs/freetype
	)
	doc? (
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	doxysearch? ( dev-libs/xapian:= )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	sqlite? ( dev-db/sqlite:3 )
	"

DEPEND="sys-devel/flex
	sys-devel/bison
	doc? ( ${PYTHON_DEPS} )
	${RDEPEND}"

# src_test() defaults to make -C testing but there is no such directory (bug #504448)
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.12-link_with_pthread.patch"
	"${FILESDIR}/${PN}-1.8.17-ensure_static_support_libraries.patch"
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
		-DGIT_EXECUTABLE="false"
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
