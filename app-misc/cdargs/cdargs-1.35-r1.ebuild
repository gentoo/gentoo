# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdargs/cdargs-1.35-r1.ebuild,v 1.6 2011/01/05 14:53:03 jlec Exp $

inherit elisp-common

DESCRIPTION="Bookmarks and browser for the shell builtin cd command"
HOMEPAGE="http://www.skamphausen.de/cgi-bin/ska/CDargs"
SRC_URI="http://www.skamphausen.de/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="emacs"

DEPEND="sys-libs/ncurses
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_compile() {
	econf
	emake || die "emake failed"

	if use emacs; then
		elisp-compile contrib/cdargs.el || die "elisp-compile failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README THANKS TODO AUTHORS || die

	cd "${S}/contrib"
	insinto /usr/share/cdargs
	doins cdargs-bash.sh cdargs-tcsh.csh \
		|| die "failed to install contrib scripts"
	if use emacs ; then
		elisp-install ${PN} cdargs.{el,elc} || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen

	echo
	elog "Add the following line to your ~/.bashrc to enable cdargs helper"
	elog "functions/aliases in your environment:"
	elog "[ -f /usr/share/cdargs/cdargs-bash.sh ] && \\ "
	elog "		source /usr/share/cdargs/cdargs-bash.sh"
	elog
	elog "Users of tcshell will find cdargs-tcsh.csh there with a reduced"
	elog "feature set.  See INSTALL file in the documentation directory for"
	elog "more information."
	echo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
