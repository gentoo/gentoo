# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 cmake-utils vim-plugin

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/Valloric/YouCompleteMe.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://dev.gentoo.org/~radhermit/vim/${P}.tar.xz"
fi

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="http://valloric.github.io/YouCompleteMe/"

LICENSE="GPL-3"
IUSE="+clang test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	clang? ( >=sys-devel/clang-3.3 )
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	)"

CMAKE_IN_SOURCE_BUILD=1
CMAKE_USE_DIR=${S}/cpp

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	if ! use test ; then
		sed -i '/^add_subdirectory( tests )/d' cpp/ycm/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use clang CLANG_COMPLETER)
		$(cmake-utils_use_use clang SYSTEM_LIBCLANG)
	)
	cmake-utils_src_configure
}

src_test() {
	# TODO: use system gmock/gtest
	cd "${S}"/cpp || die
	emake ycm_core_tests
	cd ycm/tests || die
	LD_LIBRARY_PATH="${EROOT}"/usr/$(get_libdir)/llvm \
		"${S}"/cpp/ycm/tests/ycm_core_tests || die

	cd "${S}"/python/ycm || die
	nosetests --verbose || die
}

src_install() {
	dodoc *.md
	rm -r *.md *.sh COPYING.txt cpp || die
	find python -name *test* -exec rm -rf {} + || die
	rm python/libclang.so || die

	vim-plugin_src_install

	python_optimize "${ED}"
	python_fix_shebang "${ED}"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	[[ -z ${REPLACING_VERSIONS} ]] && \
		optfeature "better python autocompletion" dev-python/jedi
}
