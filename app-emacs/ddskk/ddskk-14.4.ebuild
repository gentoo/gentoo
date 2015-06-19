# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ddskk/ddskk-14.4.ebuild,v 1.2 2013/02/12 07:56:05 naota Exp $

EAPI=3

inherit elisp

DESCRIPTION="One Japanese input methods on Emacs"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="|| ( ( =virtual/emacs-21 >=app-emacs/apel-10.7 )
			 >=virtual/emacs-22 )"
RDEPEND="${DEPEND}
	|| ( app-i18n/skk-jisyo virtual/skkserv )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	find . -type f | xargs sed -i -e "s:/usr/local:${EPREFIX}/usr:g" || die
}

src_compile() {
	emake < /dev/null || die "emake failed"
	emake info < /dev/null || die "emake info failed"
	#cd nicola
	#emake < /dev/null || die
	BYTECOMPFLAGS="${BYTECOMPFLAGS} -L .."
	cd "${S}/tut-code"
	elisp-compile *.el || die "elisp-compile tut-code/*.el failed"

	cd "${S}/bayesian"
	elisp-compile *.el || die "elisp-compile bayesian/*.el failed"
}

src_install () {
	elisp-install ${PN} *.{el,elc} nicola/*.el tut-code/*.{el,elc} bayesian/*.{el,elc} || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die

	insinto /usr/share/skk
	doins etc/*SKK.tut* etc/skk.xpm || die

	dodoc READMEs/* ChangeLog*
	doinfo doc/skk.info* || die

	#docinto nicola
	#dodoc nicola/ChangeLog* nicola/README* || die
	docinto tut-code
	dodoc tut-code/README.tut || die

	#dobin bayesian/bskk || die
	docinto bayesian
	dodoc bayesian/README.ja bayesian/bskk || die
}
