# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1 # Simplifies doc build
CMAKE_MAKEFILE_GENERATOR=emake
PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 edo cmake python-any-r1 toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ninja-build/ninja.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ninja-build/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="A small build system similar to make"
HOMEPAGE="https://ninja-build.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/re2c
	doc? (
		${PYTHON_DEPS}
		app-text/asciidoc
		app-text/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
	)
	test? ( dev-cpp/gtest )
"
PDEPEND="
	app-alternatives/ninja
"

pkg_setup() {
	:
}

docs_enabled() {
	use doc && ! tc-is-cross-compiler
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure

	if docs_enabled; then
		python_setup
		edo ${EPYTHON} configure.py
	fi
}

src_compile() {
	cmake_src_compile

	if docs_enabled; then
		edo ./ninja -v -j1 doxygen manual
	fi
}

src_test() {
	if ! tc-is-cross-compiler; then
		# Bug 485772
		ulimit -n 2048
		cmake_src_test
	fi
}

src_install() {
	cmake_src_install

	mv "${ED}"/usr/bin/ninja{,-reference} || die

	if docs_enabled; then
		docinto html
		dodoc -r doc/doxygen/html/.
		dodoc doc/manual.html
	fi

	newbashcomp misc/bash-completion ${PN}

	insinto /usr/share/vim/vimfiles/syntax/
	doins misc/ninja.vim

	echo 'au BufNewFile,BufRead *.ninja set ft=ninja' > "${T}"/ninja.vim || die
	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${T}"/ninja.vim

	insinto /usr/share/zsh/site-functions
	newins misc/zsh-completion _ninja
}

pkg_postinst() {
	if ! [[ -e "${EROOT}/usr/bin/ninja" ]]; then
		ln -s ninja-reference "${EROOT}/usr/bin/ninja" || die
	fi
}
