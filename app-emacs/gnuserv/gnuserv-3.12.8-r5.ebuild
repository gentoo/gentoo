# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp multilib desktop xdg-utils

DESCRIPTION="Attach to an already running Emacs"
HOMEPAGE="http://meltin.net/hacks/emacs/"
SRC_URI="http://meltin.net/hacks/emacs/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-linux ~ppc-macos"
IUSE="X"

RDEPEND=">=app-eselect/eselect-emacs-1.15
	X? ( x11-libs/libXau )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}"/${P}-backquotes.patch
	eapply "${FILESDIR}"/${P}-process-query.patch
	sed -i -e 's/exec gnuclient/&-emacs/' gnudoit || die
	eapply_user
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

	use X && domenu "${FILESDIR}"/gnuclient.desktop
}

pkg_postinst() {
	elisp-site-regen
	use X && xdg_desktop_database_update
	eselect gnuclient update ifunset
}

pkg_postrm() {
	elisp-site-regen
	use X && xdg_desktop_database_update
	eselect gnuclient update ifunset
}
