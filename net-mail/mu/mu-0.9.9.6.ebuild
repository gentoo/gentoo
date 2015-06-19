# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mu/mu-0.9.9.6.ebuild,v 1.2 2015/06/11 15:07:44 ago Exp $

EAPI=5

inherit autotools-utils base elisp-common

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="http://www.djcbsoftware.nl/code/mu/"
SRC_URI="https://github.com/djcb/mu/archive/v${PV}.tar.gz -> ${P}.tar.gz
		doc? ( http://mu0.googlecode.com/files/mu4e-manual-0.9.9.5.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc emacs gui"

# net-mail/mailutils also installes /usr/bin/mu.  Block it until somebody
# really wants both installed at the same time.
DEPEND="
	dev-libs/gmime:2.6
	dev-libs/xapian
	dev-libs/glib:2
	gui? (
	  x11-libs/gtk+:3
	  net-libs/webkit-gtk:3 )
	emacs? ( >=virtual/emacs-23 )
	!net-mail/mailutils"
RDEPEND="${DEPEND}"

SITEFILE="70mu-gentoo.el"

src_unpack() {
	unpack ${P}.tar.gz
	if use doc ; then
		cp "${DISTDIR}"/mu4e-manual-0.9.9.5.pdf "${S}" || die
	fi
}

src_prepare(){
	eautoreconf
}

src_configure() {
	# Todo: Make a guile USE-flag as soon as >=guile-2 is avaiable
	# Note: --disable-silent-rules is included in EAPI-5
	econf --disable-guile \
		$(use_enable gui webkit) \
		$(use_enable gui gtk) \
		$(use_enable emacs mu4e)
}

src_install () {
	base_src_install
	# Installing the guis is not supported by upstream
	if use gui; then
		dobin toys/mug/mug
	fi
	dodoc AUTHORS HACKING NEWS TODO README ChangeLog
	if use doc; then
		dodoc mu4e-manual-0.9.9.5.pdf
	fi
	if use emacs; then
		elisp-install ${PN} mu4e/*.el mu4e/*.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

src_test () {
	emake check
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "http://www.djcbsoftware.nl/code/mu/mu4e/Getting-started.html"
	fi

	elog "If you upgrade from an older major version,"
	elog "then you need to rebuild your mail index."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
