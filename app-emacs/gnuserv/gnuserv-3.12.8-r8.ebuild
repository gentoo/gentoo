# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp desktop xdg-utils

DESCRIPTION="Attach to an already running Emacs"
HOMEPAGE="https://web.archive.org/web/20160508134736/http://martin.meltin.net/hacks/emacs/
	https://www.emacswiki.org/emacs/GnuClient"
SRC_URI="https://web.archive.org/web/20150908031821/http://martin.meltin.net/sites/martin.meltin.net/files/hacks/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-linux ~ppc-macos"
IUSE="gui"

RDEPEND=">=app-eselect/eselect-emacs-1.15
	gui? ( x11-libs/libXau )"
DEPEND="${RDEPEND}
	gui? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${P}-no-custom.patch
	"${FILESDIR}"/${P}-process-query.patch
	"${FILESDIR}"/${P}-gnudoit.patch
	"${FILESDIR}"/${P}-emacs-28.patch
	"${FILESDIR}"/${P}-devices.patch
	"${FILESDIR}"/${P}-cl.patch
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-advice.patch
)
ELISP_REMOVE="devices.el"
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf $(use_enable gui xauth) \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir)
}

src_compile() {
	emake gnuserv gnuclient
	BYTECOMPFLAGS+=" -l gnuserv-compat" elisp-compile *.el
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

	use gui && domenu "${FILESDIR}"/gnuclient.desktop
}

pkg_postinst() {
	elisp-site-regen
	use gui && xdg_desktop_database_update
	eselect gnuclient update ifunset
}

pkg_postrm() {
	elisp-site-regen
	use gui && xdg_desktop_database_update
	eselect gnuclient update ifunset
}
