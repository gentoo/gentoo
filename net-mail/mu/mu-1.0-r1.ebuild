# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools elisp-common

DESCRIPTION="Set of tools to deal with Maildirs, in particular, searching and indexing"
HOMEPAGE="https://www.djcbsoftware.nl/code/mu/"
SRC_URI="https://github.com/djcb/mu/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

DEPEND="
	dev-libs/gmime:2.6
	dev-libs/xapian
	dev-libs/glib:2
	emacs? ( >=app-editors/emacs-23.1:* )"
RDEPEND="${DEPEND}"

SITEFILE="70mu-gentoo.el"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Todo: Make a guile USE-flag as soon as >=guile-2 is avaiable
	econf --disable-guile \
		--disable-gtk \
		--disable-webkit \
		$(use_enable emacs mu4e)
}

src_install() {
	dobin mu/mu
	dodoc AUTHORS HACKING NEWS NEWS.org TODO README README.org ChangeLog
	if use emacs; then
		elisp-install ${PN} mu4e/*.el mu4e/*.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		doinfo mu4e/mu4e.info
	fi
	# TODO: Add guile man page when guile-2 is available.
	doman man/mu-add.1 man/mu-bookmarks.5 man/mu-cfind.1 man/mu-easy.1 \
		  man/mu-extract.1 man/mu-find.1 man/mu-help.1 man/mu-index.1 \
		  man/mu-mkdir.1 man/mu-remove.1 man/mu-server.1 man/mu-verify.1 \
		  man/mu-view.1 man/mu.1
}

src_test() {
	# Note: Fails with parallel make
	emake -j1 check
}

pkg_postinst() {
	if use emacs; then
		einfo "To use mu4e you need to configure it in your .emacs file"
		einfo "See the manual for more information:"
		einfo "https://www.djcbsoftware.nl/code/mu/mu4e/"
	fi

	elog "If you upgrade from an older major version,"
	elog "then you need to rebuild your mail index."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
