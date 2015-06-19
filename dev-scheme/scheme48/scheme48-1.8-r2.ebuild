# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/scheme48/scheme48-1.8-r2.ebuild,v 1.4 2014/08/10 21:25:35 slyfox Exp $

EAPI=4
inherit elisp-common multilib eutils flag-o-matic

DESCRIPTION="Scheme48 is an implementation of the Scheme Programming Language"
HOMEPAGE="http://www.s48.org/"
SRC_URI="http://www.s48.org/${PV}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc emacs"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"
SITEFILE=50scheme48-gentoo.el

src_prepare() {
	epatch "${FILESDIR}/${P}-as-needed+fix_destdir.patch"
	sed -i -e "s/\$(LD) /&\$(LFLAGS) /" Makefile.in || die #332007
}

src_compile() {
	emake LFLAGS="$(raw-ldflags)"
	if use emacs; then
		elisp-compile "${S}"/emacs/cmuscheme48.el
	fi
}

src_install() {
	# weird parallel failures!
	emake -j1 DESTDIR="${D}" install

	if use emacs; then
		elisp-install ${PN} emacs/cmuscheme48.el emacs/*.elc
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	dodoc README
	if use doc; then
		dodoc doc/manual.ps doc/manual.pdf doc/*.txt
		dohtml -r doc/html/*
		docinto src
		dodoc doc/src/*
	fi

	#this symlink clashes with gambit
	rm "${ED}"/usr/bin/scheme-r5rs || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
