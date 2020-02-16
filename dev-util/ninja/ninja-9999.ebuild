# Copyright 2012-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit bash-completion-r1 elisp-common python-any-r1 toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ninja-build/ninja.git"
else
	KITWARE_VERSION="1.9.0.g99df1.kitware.dyndep-1.jobserver-1"
	MY_P="ninja-${KITWARE_VERSION}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/Kitware/ninja/archive/v${KITWARE_VERSION}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
fi

DESCRIPTION="A small build system similar to make"
HOMEPAGE="https://ninja-build.org/"

LICENSE="Apache-2.0"
SLOT="0"

IUSE="doc emacs test vim-syntax"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/re2c
	doc? (
		app-text/asciidoc
		app-doc/doxygen
		dev-libs/libxslt
	)
	test? ( dev-cpp/gtest )
"
RDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
"

run_for_build() {
	if tc-is-cross-compiler; then
		local -x AR=$(tc-getBUILD_AR)
		local -x CXX=$(tc-getBUILD_CXX)
		local -x CFLAGS=
		local -x CXXFLAGS=${BUILD_CXXFLAGS}
		local -x LDFLAGS=${BUILD_LDFLAGS}
	fi
	echo "$@" >&2
	"$@"
}

src_compile() {
	tc-export AR CXX

	# configure.py uses CFLAGS instead of CXXFLAGS
	export CFLAGS=${CXXFLAGS}

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

	if use emacs; then
		elisp-compile misc/ninja-mode.el || die
	fi
}

src_test() {
	if ! tc-is-cross-compiler; then
		# Bug 485772
		ulimit -n 2048
		./ninja -v ninja_test || die
		./ninja_test || die
	fi
}

src_install() {
	dodoc README HACKING.md
	if use doc; then
		docinto html
		dodoc -r doc/doxygen/html/.
		dodoc doc/manual.html
	fi
	dobin ninja

	newbashcomp misc/bash-completion "${PN}"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins misc/ninja.vim

		echo 'au BufNewFile,BufRead *.ninja set ft=ninja' > "${T}/ninja.vim"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${T}/ninja.vim"
	fi

	insinto /usr/share/zsh/site-functions
	newins misc/zsh-completion _ninja

	if use emacs; then
		cd misc || die
		elisp-install ninja ninja-mode.el* || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
