# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp multilib fdo-mime

DESCRIPTION="Attach to an already running Emacs"
HOMEPAGE="http://meltin.net/hacks/emacs/"
SRC_URI="http://meltin.net/hacks/emacs/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-linux ~ppc-macos"
IUSE="X"

DEPEND=">=app-eselect/eselect-emacs-1.15
	X? ( x11-libs/libXau )"
RDEPEND="${DEPEND}
	!!app-emacs/gnuserv-programs
	!!<app-editors/xemacs-21.4.22-r3
	!!~app-editors/xemacs-21.5.29 !!~app-editors/xemacs-21.5.30
	!!~app-editors/xemacs-21.5.31 !!~app-editors/xemacs-21.5.33
	!!=app-editors/xemacs-21.5.34 !!=app-editors/xemacs-21.5.34-r1"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i -e 's/exec gnuclient/&-emacs/' gnudoit || die
}

src_configure() {
	econf $(use_enable X xauth) \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir)
}

src_compile() {
	default
}

src_install() {
	exeinto /usr/libexec/emacs
	doexe gnuserv
	newbin gnuclient gnuclient-emacs
	newbin gnudoit gnudoit-emacs
	# Don't install gnuattach, it is not functional with FSF GNU Emacs

	newman gnuserv.1 gnuserv-emacs.1
	echo ".so man1/gnuserv-emacs.1" | newman - gnuclient-emacs.1
	echo ".so man1/gnuserv-emacs.1" | newman - gnudoit-emacs.1

	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog README README.orig

	if use X; then
		domenu "${FILESDIR}"/gnuclient.desktop || die
	fi
}

pkg_postinst() {
	elisp-site-regen
	use X && fdo-mime_desktop_database_update
	eselect gnuclient update ifunset
}

pkg_postrm() {
	elisp-site-regen
	use X && fdo-mime_desktop_database_update
	eselect gnuclient update ifunset
}
