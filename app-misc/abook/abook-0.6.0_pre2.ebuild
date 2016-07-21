# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

MY_P="${P/_/}"
DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
HOMEPAGE="http://abook.sourceforge.net/"
SRC_URI="http://abook.sourceforge.net/devel/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-vcard-import.patch
	epatch "${FILESDIR}"/${P}-vcard-fix.patch
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	# bug 570428
	emake CFLAGS="${CFLAGS} -std=gnu89"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc BUGS ChangeLog FAQ README TODO sample.abookrc || die "dodoc failed"
}
