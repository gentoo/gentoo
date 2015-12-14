# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils base elisp-common

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="http://www.djcbsoftware.nl/code/mu/"
SRC_URI="https://github.com/djcb/mu/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs gui"

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
	dobin mu/mu
	if use gui; then
		dobin toys/mug/mug
	fi
	dodoc AUTHORS HACKING NEWS NEWS.org TODO README README.org ChangeLog
	if use emacs; then
		elisp-install ${PN} mu4e/*.el mu4e/*.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	# TODO: Add guile man page when guile-2 is available.
	doman man/mu-add.1 man/mu-bookmarks.5 man/mu-cfind.1 man/mu-easy.1 \
		  man/mu-extract.1 man/mu-find.1 man/mu-help.1 man/mu-index.1 \
		  man/mu-mkdir.1 man/mu-remove.1 man/mu-server.1 man/mu-verify.1 \
		  man/mu-view.1 man/mu.1
	if use gui; then
		dobin man/mug.1
	fi
}

src_test () {
	# Note: Fails with parallel make
	emake -j1 check
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "http://www.djcbsoftware.nl/code/mu/mu4e/"
	fi

	elog "If you upgrade from an older major version,"
	elog "then you need to rebuild your mail index."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
