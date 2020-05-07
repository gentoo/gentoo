# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit check-reqs cmake-utils python-single-r1 python-utils-r1 bash-completion-r1

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="https://www.ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc emacs python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"

CHECKREQS_MEMORY=8G

RDEPEND="
	dev-libs/boost:=[python?]
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	python? (
		$(python_gen_cond_dep '
			dev-libs/boost:=[${PYTHON_USEDEP}]
			dev-python/cheetah3:=[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/utfcpp
	doc? (
		sys-apps/texinfo
		virtual/texi2dvi
		dev-texlive/texlive-fontsrecommended
	)
"

# Building with python integration seems to fail without 8G available
# RAM(!)  Since the memory check in check-reqs doesn't count swap, it
# may be unfair to fail the build entirely on the memory test alone.
# Therefore check-reqs_pkg_pretend is deliberately omitted so that we
# ewarn but not eerror.
pkg_pretend() {
	:
}

pkg_setup() {
	if use python; then
		check-reqs_pkg_setup
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	# Want to type "info ledger" not "info ledger3"
	sed -i -e 's/ledger3/ledger/g' \
		doc/ledger3.texi \
		doc/CMakeLists.txt \
		test/CheckTexinfo.py \
		tools/cleanup.sh \
		tools/gendocs.sh \
		tools/prepare-commit-msg \
		tools/spellcheck.sh \
		|| die "Failed to update info file name in file contents"

	mv doc/ledger{3,}.texi || die "Failed to rename info file name"

	rm -r lib/utfcpp || die
	rm cmake/FindPython.cmake || die
	rm -r cmake/FindPython || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_WEB_DOCS="$(usex doc)"
		-DUSE_PYTHON="$(usex python)"
		-DPython_EXECUTABLE="${PYTHON}"
		-DPython_INCLUDE_DIR="$(python_get_includedir)"
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DBUILD_DEBUG="$(usex debug)"
		-DUTFCPP_PATH="/usr/include/utf8cpp"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_make doc
}

src_install() {
	cmake-utils_src_install

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
