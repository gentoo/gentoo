# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/slime/slime-2.0_p20080731-r1.ebuild,v 1.4 2012/04/07 14:58:43 ulm Exp $

EAPI=3

inherit common-lisp elisp eutils

DESCRIPTION="SLIME, the Superior Lisp Interaction Mode (Extended)"
HOMEPAGE="http://common-lisp.net/project/slime/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${P}-patches.tar.bz2"

LICENSE="GPL-2 xref? ( xref.lisp )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc xref"

RDEPEND="virtual/commonlisp
	dev-lisp/asdf"
DEPEND="${RDEPEND}
	doc? ( virtual/texi2dvi )"

CLPACKAGE=swank
SITEFILE="70${PN}-gentoo.el"

src_prepare() {
	EPATCH_SUFFIX=patch epatch
	mv "${WORKDIR}/swank.asd" "${S}" || die

	# extract date of last update from ChangeLog, bug 233270
	SLIME_CHANGELOG_DATE=$(awk '/^[-0-9]+ / { print $1; exit; }' ChangeLog)
	[ -n "${SLIME_CHANGELOG_DATE}" ] || die "cannot determine ChangeLog date"

	sed -i "/(defvar \*swank-wire-protocol-version\*/s:nil:\"${SLIME_CHANGELOG_DATE}\":" swank.lisp || die
	sed -i "s:@SLIME-CHANGELOG-DATE@:${SLIME_CHANGELOG_DATE}:" slime.el || die

	# Remove xref.lisp (which is non-free) unless USE flag is set
	use xref || rm -f xref.lisp
}

src_compile() {
	elisp-compile *.el || die
	BYTECOMPFLAGS="${BYTECOMPFLAGS} -L contrib -l slime" \
		elisp-compile contrib/*.el || die
	emake -j1 -C doc slime.info || die

	if use doc; then
		VARTEXFONTS="${T}/fonts" emake -j1 -C doc slime.{ps,pdf} || die
	fi
}

src_install() {
	## install core
	elisp-install ${PN} *.{el,elc} "${FILESDIR}/swank-loader.lisp" || die
	sed "s:/usr/:${EPREFIX}&:g" "${FILESDIR}/${SITEFILE}" >"${T}/${SITEFILE}" \
		|| die
	elisp-site-file-install "${T}/${SITEFILE}" || die

	# remove upstream swank-loader, since it won't be used
	rm "${S}/swank-loader.lisp"

	insinto "${CLSOURCEROOT%/}/swank"
	doins *.lisp swank.asd || die
	dodir "${CLSYSTEMROOT}" || die
	dosym "${CLSOURCEROOT%/}/swank/swank.asd" "${CLSYSTEMROOT}" || die

	## install contribs
	elisp-install ${PN}/contrib/ contrib/*.{el,elc,scm,goo} || die
	insinto "${CLSOURCEROOT%/}/swank/contrib"
	doins contrib/*.lisp || die

	## install docs
	doinfo doc/slime.info || die
	dodoc README* ChangeLog HACKING NEWS PROBLEMS
	newdoc contrib/README README.contrib
	newdoc contrib/ChangeLog ChangeLog.contrib
	use doc && dodoc doc/slime.{ps,pdf}
}
