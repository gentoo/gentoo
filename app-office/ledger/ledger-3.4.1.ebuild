# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12,13,14} )
CMAKE_REMOVE_MODULES_LIST=( FindPython Support )
inherit bash-completion-r1 check-reqs cmake optfeature python-single-r1

DESCRIPTION="Double-entry accounting system with a command-line reporting interface"
HOMEPAGE="https://www.ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
IUSE="debug doc gpg python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="test"

CHECKREQS_MEMORY=8G

RDEPEND="
	dev-libs/boost:=[icu,python?]
	dev-libs/gmp:0=
	gpg? (
		dev-cpp/gpgmepp
	)
	dev-libs/mpfr:0=
	python? (
		$(python_gen_cond_dep '
			dev-libs/boost:=[${PYTHON_USEDEP}]
			dev-python/cheetah3:=[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
	doc? (
		app-text/texlive[extra]
		sys-apps/texinfo
		virtual/texi2dvi
	)
"

pkg_pretend() {
	if use python; then
		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if use python; then
		check-reqs_pkg_setup
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# use system utfcpp
	rm -r lib/utfcpp || die

	# Fix a test of gmp's version
	eapply "${FILESDIR}/cmake.patch"

	cmake_src_prepare

	# Want to type "info ledger" not "info ledger3"
	sed -i -e 's/ledger3/ledger/g' \
		doc/{CMakeLists.txt,ledger.1,ledger3.texi} test/CheckTexinfo.py \
		tools/{cleanup.sh,gendocs.sh,prepare-commit-msg,spellcheck.sh} \
		|| die "Failed to update info file name in file contents"
	mv doc/ledger{3,}.texi || die "Failed to rename info file name"

	# Avoid conflicting ledger.html outputs when doc and python are enabled
	sed -i -e 's/\${file_base}.html/\${file_base}.info.html/g' \
		doc/CMakeLists.txt \
		|| die "Failed to update info HTML file name in file contents"

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_WEB_DOCS="$(usex doc)"
		-DUSE_GPGME="$(usex gpg)"
		-DUSE_PYTHON="$(usex python)"
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DCMAKE_BUILD_TYPE="$(usex debug Debug Release)"
		-DUTFCPP_PATH="${ESYSROOT}/usr/include/utf8cpp"
	)
	if use python; then
		mycmakeargs+=(
			-DPython_EXECUTABLE="${PYTHON}"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	# Requires gnuplot
	exeinto /usr/bin
	doexe contrib/report

	newbashcomp contrib/${PN}-completion.bash ${PN}
}

pkg_postinst() {
	elog
	elog "Vim support is released separately. See"
	elog "https://github.com/ledger/vim-ledger"
	optfeature_header \
		"Install the following packages for additional features:"
	optfeature "Emacs support" "app-emacs/ledger-mode"
	optfeature "Plot visualization" "sci-visualization/gnuplot"
	optfeature "Graph visualization" "media-gfx/graphviz"
}

# rainy day TODO:
# - IUSE test
