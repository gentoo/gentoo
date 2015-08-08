# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="MicroGnuEmacs, a port from the BSDs"
HOMEPAGE="http://homepage.boetes.org/software/mg/"
SRC_URI="http://homepage.boetes.org/software/mg/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="livecd"

RDEPEND="sys-libs/ncurses
	!elibc_FreeBSD? ( >=dev-libs/libbsd-0.7.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user

	# remove OpenBSD specific easter egg
	sed -i -e 's/theo\.o//' GNUmakefile || die
	sed -i -e '/theo_init/d' main.c || die

	# fix path to tutorial in man page
	sed -i -e "s:doc/mg/:doc/${PF}/:" mg.1 || die
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CURSES_LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install()  {
	dobin mg
	doman mg.1
	dodoc README tutorial
	# don't compress the tutorial, otherwise mg cannot open it
	docompress -x /usr/share/doc/${PF}/tutorial
}

pkg_postinst() {
	if use livecd; then
		[[ -e ${EROOT}/usr/bin/emacs ]] || ln -s mg "${EROOT}"/usr/bin/emacs
	fi
}
