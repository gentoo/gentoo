# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hteditor/hteditor-2.1.0.ebuild,v 1.1 2015/01/17 01:32:26 radhermit Exp $

EAPI=5

inherit toolchain-funcs

MY_P=${P/editor}

DESCRIPTION="A file viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="http://hte.sourceforge.net/ https://github.com/sebastianbiallas/ht/"
SRC_URI="mirror://sourceforge/hte/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

DOCS=( AUTHORS ChangeLog KNOWNBUGS README TODO )

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_enable X x11-textmode) \
		--enable-maintainermode
}

src_compile() {
	emake AR="$(tc-getAR)" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	#For prefix
	chmod u+x "${S}/install-sh"

	default

	dohtml doc/*.html
	doinfo doc/*.info
}
