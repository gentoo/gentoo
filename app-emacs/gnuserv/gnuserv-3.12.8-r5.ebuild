# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp desktop xdg-utils

DESCRIPTION="Attach to an already running Emacs"
HOMEPAGE="https://web.archive.org/web/20160508134736/http://martin.meltin.net/hacks/emacs/
	https://www.emacswiki.org/emacs/GnuClient"
SRC_URI="https://web.archive.org/web/20150908031821/http://martin.meltin.net/sites/martin.meltin.net/files/hacks/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-linux ~ppc-macos"
IUSE="X"

RDEPEND=">=app-eselect/eselect-emacs-1.15
	X? ( x11-libs/libXau )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-backquotes.patch
	"${FILESDIR}"/${P}-process-query.patch
	"${FILESDIR}"/${P}-gnudoit.patch
	"${FILESDIR}"/${P}-emacs-28.patch
)
SITEFILE="50${PN}-gentoo.el"

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
