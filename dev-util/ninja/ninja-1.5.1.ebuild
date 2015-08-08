# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 elisp-common python-any-r1 toolchain-funcs

if [ "${PV}" = "999999" ]; then
	EGIT_REPO_URI="git://github.com/martine/ninja.git http://github.com/martine/ninja.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="https://github.com/martine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 ~m68k ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
fi

DESCRIPTION="A small build system similar to make"
HOMEPAGE="http://github.com/martine/ninja"

LICENSE="Apache-2.0"
SLOT="0"

IUSE="doc emacs test vim-syntax zsh-completion"

DEPEND="
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
	emacs? ( virtual/emacs )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
	zsh-completion? ( app-shells/zsh )
	!<net-irc/ninja-1.5.9_pre14-r1" #436804

run_for_build() {
	if tc-is-cross-compiler; then
		local -x AR=$(tc-getBUILD_AR)
		local -x CXX=$(tc-getBUILD_CXX)
		local -x CFLAGS=${BUILD_CXXFLAGS}
		local -x LDFLAGS=${BUILD_LDFLAGS}
	fi
	"$@"
}

src_compile() {
	tc-export AR CXX

	# configure.py uses CFLAGS instead of CXXFLAGS
	export CFLAGS=${CXXFLAGS}

	run_for_build "${PYTHON}" bootstrap.py --verbose || die

	if tc-is-cross-compiler; then
		mv ninja ninja-build || die
		"${PYTHON}" configure.py || die
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
		./ninja-build -v ninja_test || die
		./ninja_test || die
	fi
}

src_install() {
	dodoc README HACKING.md
	if use doc; then
		dohtml -r doc/doxygen/html/*
		dohtml doc/manual.html
	fi
	dobin ninja

	newbashcomp misc/bash-completion "${PN}"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins misc/"${PN}".vim

		echo 'au BufNewFile,BufRead *.ninja set ft=ninja' > "${T}/${PN}.vim"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${T}/${PN}.vim"
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins misc/zsh-completion _ninja
	fi

	if use emacs; then
		cd misc || die
		elisp-install ${PN} ninja-mode.el* || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
