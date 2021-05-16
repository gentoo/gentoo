# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="Bookmarks and browser for the shell builtin cd command"
HOMEPAGE="http://www.skamphausen.de/cgi-bin/ska/CDargs"
SRC_URI="http://www.skamphausen.de/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="emacs"

DEPEND="
	sys-libs/ncurses:0=
	emacs? ( >=app-editors/emacs-23.1:* )
"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}"/${P}-format_security.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	default

	use emacs && elisp-compile contrib/cdargs.el
}

src_install() {
	default

	cd "${S}"/contrib || die
	insinto /usr/share/cdargs
	doins cdargs-bash.sh cdargs-tcsh.csh

	if use emacs ; then
		elisp-install ${PN} cdargs.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
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
