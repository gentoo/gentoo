# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/bc/bc-1.06.95.ebuild,v 1.15 2014/01/18 03:08:45 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="http://www.gnu.org/software/bc/bc.html"
SRC_URI="mirror://gnu-alpha/bc/${P}.tar.bz2
	mirror://gnu/bc/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit readline static"

RDEPEND="readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	libedit? ( dev-libs/libedit )"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	local myconf
	if use readline ; then
		myconf="--with-readline --without-libedit"
	elif use libedit ; then
		myconf="--without-readline --with-libedit"
	else
		myconf="--without-readline --without-libedit"
	fi
	use static && append-ldflags -static
	econf ${myconf} || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS FAQ NEWS README ChangeLog
}
