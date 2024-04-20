# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit edo bash-completion-r1 python-any-r1 toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ninja-build/ninja.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ninja-build/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="A small build system similar to make"
HOMEPAGE="https://ninja-build.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/re2c
	doc? (
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

PATCHES=(
	"${FILESDIR}"/ninja-cflags.patch
)

run_for_build() {
	if tc-is-cross-compiler; then
		local -x AR=$(tc-getBUILD_AR)
		local -x CXX=$(tc-getBUILD_CXX)
		local -x CFLAGS=
		local -x CXXFLAGS="${BUILD_CXXFLAGS} -D_FILE_OFFSET_BITS=64"
		local -x LDFLAGS=${BUILD_LDFLAGS}
	fi
	echo "$@" >&2
	"$@"
}

src_compile() {
	tc-export AR CXX

	# configure.py appends CFLAGS to CXXFLAGS
	unset CFLAGS

	local -x CXXFLAGS="${CXXFLAGS} -D_FILE_OFFSET_BITS=64"

	run_for_build ${EPYTHON} configure.py --bootstrap --verbose || die

	if tc-is-cross-compiler; then
		mv ninja ninja-build || die
		${EPYTHON} configure.py || die
		./ninja-build -v ninja || die
	else
		ln ninja ninja-build || die
	fi

	if use doc; then
		./ninja-build -v doxygen manual || die
	fi
}

src_test() {
	if ! tc-is-cross-compiler; then
		# Bug 485772
		ulimit -n 2048
		edo ./ninja -v ninja_test
		edo ./ninja_test
	fi
}

src_install() {
	dodoc README.md CONTRIBUTING.md

	if use doc; then
		docinto html
		dodoc -r doc/doxygen/html/.
		dodoc doc/manual.html
	fi

	newbin ninja ninja-reference

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
