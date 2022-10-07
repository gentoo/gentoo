# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
CMAKE_REMOVE_MODULES_LIST=( FindPython Support )
inherit bash-completion-r1 check-reqs cmake python-single-r1

DESCRIPTION="Double-entry accounting system with a command-line reporting interface"
HOMEPAGE="https://www.ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="debug doc python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="test"

CHECKREQS_MEMORY=8G

RDEPEND="
	dev-libs/boost:=[python?]
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	python? (
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
			dev-python/cheetah3:=[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
	doc? (
		dev-texlive/texlive-fontsrecommended
		sys-apps/texinfo
		virtual/texi2dvi
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-fix-build-boost-1-76.patch
)

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
	cmake_src_prepare

	# Want to type "info ledger" not "info ledger3"
	sed -i -e 's/ledger3/ledger/g' \
		doc/{CMakeLists.txt,ledger3.texi} test/CheckTexinfo.py \
		tools/{cleanup.sh,gendocs.sh,prepare-commit-msg,spellcheck.sh} \
		|| die "Failed to update info file name in file contents"

	mv doc/ledger{3,}.texi || die "Failed to rename info file name"

	rm -r lib/utfcpp || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_WEB_DOCS="$(usex doc)"
		-DUSE_PYTHON="$(usex python)"
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DBUILD_DEBUG="$(usex debug)"
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

	newbashcomp contrib/${PN}-completion.bash ${PN}
}

pkg_postinst() {
	elog
	elog "Since version 3, vim support is released separately."
	elog "See https://github.com/ledger/vim-ledger"
	elog
	elog "For Emacs mode, emerge app-emacs/ledger-mode"
}

# rainy day TODO:
# - IUSE test
