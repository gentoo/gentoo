# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Source metrics (line counts, complexity, etc) for Java and C++"
HOMEPAGE="https://sarnold.github.io/cccc/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/cccc.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="apidoc debug doc mfc"

BDEPEND="apidoc? ( app-doc/doxygen[dot] )"

src_prepare() {
	default

	use mfc && eapply "${FILESDIR}"/${PN}-c_dialect.patch
	is-flagq -flto* && filter-flags -flto* -fuse-linker-plugin
}

src_compile() {
	tc-export CC CXX LD AS AR NM RANLIB STRIP OBJCOPY
	if use debug ; then
		DEBUG="true" emake -j1 CCC="$(tc-getCXX)" CC="$(tc-getCC)" cccc
	else
		emake -j1 CCC="$(tc-getCXX)" CC="$(tc-getCC)" cccc
	fi

	use apidoc && emake -j1 CCC="$(tc-getCXX)" metrics docs
}

src_test() {
	emake -j1 CCC="$(tc-getCXX)" test
}

src_install() {
	dobin cccc/cccc

	dodoc README.md

	if use mfc ; then
		docinto examples
		dodoc "${FILESDIR}"/cccc-MFC-dialect.opt
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	if use doc ; then
		docinto html
		dodoc cccc/*.html
		if use apidoc ; then
			docinto html/api
			dodoc -r doxygen/html/.

			docinto html/metrics/
			dodoc ccccout/*
		fi
	fi
}
