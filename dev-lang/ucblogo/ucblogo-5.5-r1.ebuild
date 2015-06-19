# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ucblogo/ucblogo-5.5-r1.ebuild,v 1.3 2012/10/05 18:42:31 ago Exp $

inherit eutils elisp-common toolchain-funcs

DESCRIPTION="a reflective, functional programming language"
HOMEPAGE="http://www.cs.berkeley.edu/~bh/logo.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="emacs X"

DEPEND="emacs? ( virtual/emacs )
	X? ( x11-libs/libICE x11-libs/libSM x11-libs/libX11 )"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-fhs.patch
	epatch "${FILESDIR}"/${P}-dont-require-tetex.patch
	use emacs || epatch "${FILESDIR}"/${P}-no-emacs.patch
#	use emacs || echo 'all install:' > emacs/makefile
}

src_compile() {
	econf $(use_with X x) || die
	emake CC="$(tc-getCC)" || die
}

src_install() {
	make install DESTDIR="${D}" || die
	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
