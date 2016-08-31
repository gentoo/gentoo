# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/jonas/tig.git"
	inherit git-r3 autotools
else
	SRC_URI="http://jonas.nitro.dk/tig/releases/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
fi

DESCRIPTION="text mode interface for git"
HOMEPAGE="http://jonas.nitro.dk/tig/"

LICENSE="GPL-2"
SLOT="0"
IUSE="unicode"

DEPEND="
	sys-libs/ncurses:0=[unicode?]
	sys-libs/readline:0="
RDEPEND="${DEPEND}
	dev-vcs/git"
[[ ${PV} == "9999" ]] && DEPEND+=" app-text/asciidoc"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf $(use_with unicode ncursesw)
}

src_compile() {
	emake V=1
	[[ ${PV} == "9999" ]] && emake V=1 doc-man doc-html
}

src_test() {
	# workaround parallel test failures
	emake -j1 test
}

src_install() {
	emake DESTDIR="${D}" install install-doc-man
	dodoc doc/manual.html README.html NEWS.html
	newbashcomp contrib/tig-completion.bash ${PN}

	docinto examples
	dodoc contrib/*.tigrc
}
