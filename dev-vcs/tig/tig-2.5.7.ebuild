# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/jonas/tig.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/jonas/tig/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

DESCRIPTION="text mode interface for git"
HOMEPAGE="https://jonas.github.io/tig/"

LICENSE="GPL-2"
SLOT="0"
IUSE="pcre test unicode"
REQUIRED_USE="test? ( unicode )"

DEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	sys-libs/readline:0=
	pcre? ( dev-libs/libpcre2:= )
"
RDEPEND="
	${DEPEND}
	dev-vcs/git
"
[[ ${PV} == "9999" ]] && BDEPEND+=" app-text/asciidoc app-text/xmlto"

# encoding/env issues
RESTRICT="test"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_with pcre) \
		$(use_with unicode ncursesw)
}

src_compile() {
	emake V=1
	[[ ${PV} == "9999" ]] && emake V=1 doc-man doc-html
}

src_test() {
	# workaround parallel test failures
	LC_ALL=en_US.utf8 emake -j1 test
}

src_install() {
	emake DESTDIR="${D}" install install-doc-man
	dodoc doc/manual.html README.html NEWS.html
	newbashcomp contrib/tig-completion.bash ${PN}

	docinto examples
	dodoc contrib/*.tigrc
}
