# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 cmake java-pkg-opt-2 python-single-r1

DESCRIPTION="Datalog compiler, synthesizes C++ program from logic specification"
HOMEPAGE="http://souffle-lang.github.io/
	https://github.com/souffle-lang/souffle/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/souffle-lang/${PN}.git"
else
	SRC_URI="https://github.com/souffle-lang/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="UPL-1.0"
SLOT="0"
IUSE="+ffi java +ncurses +openmp python +sqlite swig test +zlib"
REQUIRED_USE="java? ( swig ) python? ( swig ) test? ( ${PYTHON_REQUIRED_USE} )"

# Still, some tests fail. TODO: Disable them.
# RESTRICT="!test? ( test )"
RESTRICT="test"

RDEPEND="
	ffi? ( dev-libs/libffi:= )
	ncurses? ( sys-libs/ncurses:= )
	openmp? ( sys-libs/libomp:= )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3 )
	swig? ( dev-lang/swig:= )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="
	${RDEPEND}
	java? ( >=virtual/jdk-1.8 )
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.1-ncurses.patch"
)

pkg_pretend() {
	if [[ "${MERGE_TYPE}" != binary ]] ; then
		if has ccache "${FEATURES}" && use test ; then
			ewarn "Very many tests fail with ccache enabled."
		fi
	fi
}

pkg_setup() {
	if use java ; then
		java-pkg-opt-2_pkg_setup
	fi

	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	unset LEX

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		# Configure bash completions.
		-DBASH_COMPLETION_COMPLETIONSDIR=$(get_bashcompdir)
		-DSOUFFLE_BASH_COMPLETION=ON

		# Disable developer tests.
		-DSOUFFLE_TEST_EVALUATION=OFF
		-DSOUFFLE_TEST_EXAMPLES=OFF

		-DSOUFFLE_ENABLE_TESTING=$(usex test)
		-DSOUFFLE_SWIG_JAVA=$(usex java)
		-DSOUFFLE_SWIG_PYTHON=$(usex python)
		-DSOUFFLE_USE_CURSES=$(usex ncurses)
		-DSOUFFLE_USE_LIBFFI=$(usex ffi)
		-DSOUFFLE_USE_OPENMP=$(usex openmp)
		-DSOUFFLE_USE_SQLITE=$(usex sqlite)
		-DSOUFFLE_USE_ZLIB=$(usex zlib)
	)

	# Version information for non-git, non-live builds.
	if ! has live "${PROPERTIES}" ; then
		mycmakeargs+=(
			-DSOUFFLE_GIT=OFF
			-DSOUFFLE_VERSION="${PV}"
		)
	fi

	if use ffi ; then
		mycmakeargs+=(
			-DLIBFFI_INCLUDE_DIR="${EPREFIX}/usr/$(get_libdir)/libffi/include"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doman man/*.1
}
