# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="http://bbdb.sourceforge.net/"
SRC_URI="http://bbdb.sourceforge.net/${P}.tar.gz
	http://www.mit.edu/afs/athena/contrib/emacs-contrib/Fin/point-at.el
	http://www.mit.edu/afs/athena/contrib/emacs-contrib/Fin/dates.el"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="tex"

RDEPEND="tex? ( virtual/tex-base )"

SITEFILE="50${PN}-gentoo.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	sed -i -e '0,/^--- bbdb-mail-folders.el ---$/d;/^--- end ---$/,$d' \
		bits/bbdb-mail-folders.el || die "sed failed"
	sed -i -e '/^;/,$!d' bits/bbdb-sort-mailrc.el || die "sed failed"
	cp "${DISTDIR}"/{dates,point-at}.el bits || die "cp failed"
}

src_configure() {
	default
}

src_compile() {
	emake -j1
	BYTECOMPFLAGS="-L bits -L lisp"	elisp-compile bits/*.el || die
}

src_install() {
	elisp-install ${PN} lisp/*.el{,c} || die
	elisp-install ${PN}/bits bits/*.el{,c} || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	doinfo texinfo/*.info*
	dodoc ChangeLog INSTALL README bits/*.txt
	newdoc bits/README README.bits
	if use tex; then
		insinto "${TEXMF}"/tex/plain/bbdb
		doins tex/*.tex
	fi
}

pkg_postinst() {
	elisp-site-regen
	use tex && texconfig rehash

	elog "If you use encryption or signing, you may specify the encryption"
	elog "method by customising variable \"bbdb/pgp-method\". For details,"
	elog "see the documentation of this variable. Depending on the Emacs"
	elog "version, installation of additional packages like app-emacs/gnus"
	elog "or app-emacs/mailcrypt may be required."
}

pkg_postrm() {
	elisp-site-regen
	use tex && texconfig rehash
}
