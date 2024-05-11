# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 edo python-any-r1 toolchain-funcs

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
IUSE="doc"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/re2c
	doc? (
		app-text/asciidoc
		app-text/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
	)
"
PDEPEND="
	app-alternatives/ninja
"

pkg_setup() {
	:
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/ninja-cflags.patch
	)
	default
}

bootstrap() {
	if tc-is-cross-compiler; then
		local -x AR=$(tc-getBUILD_AR)
		local -x CXX=$(tc-getBUILD_CXX)
		local -x CFLAGS=
		local -x CXXFLAGS="${BUILD_CXXFLAGS} -D_FILE_OFFSET_BITS=64"
		local -x LDFLAGS=${BUILD_LDFLAGS}
	fi
	edo ${EPYTHON} configure.py --with-python=python --bootstrap --verbose
}

src_compile() {
	python_setup

	tc-export AR CXX
	unset CFLAGS
	export CXXFLAGS="${CXXFLAGS} -D_FILE_OFFSET_BITS=64"

	bootstrap

	if use doc; then
		edo ./ninja -v doxygen manual
	fi

	if tc-is-cross-compiler; then
		edo ${EPYTHON} configure.py --with-python=python
		edo ./ninja -v ninja
	fi
}

src_install() {
	newbin ninja{,-reference}

	if use doc; then
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
