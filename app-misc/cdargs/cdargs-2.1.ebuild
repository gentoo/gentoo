# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson elisp-common

DESCRIPTION="Bookmarks and browser for the shell builtin cd command"
HOMEPAGE="https://www.skamphausen.de/cgi-bin/ska/CDargs https://github.com/cbxbiker61/cdargs"
SRC_URI="https://github.com/cbxbiker61/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="emacs"

DEPEND="
	sys-libs/ncurses:0=
	emacs? ( >=app-editors/emacs-23.1:* )
"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}"/${PN}-1.35-format_security.patch
	"${FILESDIR}"/${PN}-1.35-tinfo.patch
	"${FILESDIR}"/${PN}-2.1-musl.patch
)

src_compile() {
	meson_src_compile

	use emacs && elisp-compile contrib/cdargs.el
}

src_install() {
	meson_src_install

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

	elog "Add the following line to your ~/.bashrc to enable cdargs helper"
	elog "functions/aliases in your environment:"
	elog "[ -f /usr/share/cdargs/cdargs-bash.sh ] && \\ "
	elog "		source /usr/share/cdargs/cdargs-bash.sh"
	elog
	elog "Users of tcshell will find cdargs-tcsh.csh there with a reduced"
	elog "feature set.  See INSTALL file in the documentation directory for"
	elog "more information."
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
