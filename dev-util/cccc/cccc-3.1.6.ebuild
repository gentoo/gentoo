# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Source metrics (line counts, complexity, etc) for Java and C++"
HOMEPAGE="http://sarnold.github.io/cccc/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/cccc.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="apidoc debug doc mfc"

RDEPEND=""
DEPEND="${RDEPEND}
	apidoc? ( app-doc/doxygen[dot] )
	"

PATCHES=( "${FILESDIR}/${PN}-fix-tests-for-name-swap.patch" )

src_prepare() {
	is-flagq -flto* && filter-flags -flto* -fuse-linker-plugin
	use mfc && eapply "${FILESDIR}"/${PN}-c_dialect.patch
	default

}

src_compile() {
	tc-export CC CXX LD AS AR NM RANLIB STRIP OBJCOPY
	if use debug ; then
		DEBUG="true" emake -j1 CCC=$(tc-getCXX) CC=$(tc-getCC) cccc
	else
		emake -j1 CCC=$(tc-getCXX) CC=$(tc-getCC) cccc
	fi

	use apidoc && emake -j1 CCC=$(tc-getCXX) metrics docs
}

src_test() {
	emake -j1 CCC=$(tc-getCXX) test
}

src_install() {
	dobin cccc/cccc

	dodoc README.md

	if use mfc ; then
		insinto /usr/share/doc/${PF}
		doins "${FILESDIR}"/cccc-MFC-dialect.opt
	fi

	if use doc ; then
		insinto /usr/share/doc/${PF}/html
		doins cccc/*.html || die "html docs failed"
		if use apidoc ; then
			insinto /usr/share/doc/${PF}/html/api
			doins -r doxygen/html/* || die "dox failed"
			insinto /usr/share/doc/${PF}/html/metrics
			doins ccccout/* || die "metrics failed"
		fi
	fi
}
