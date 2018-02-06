# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp readme.gentoo-r1

DESCRIPTION="Elisp client for the LysKOM conference system"
HOMEPAGE="http://www.lysator.liu.se/lyskom/klienter/emacslisp/index.en.html"
# snapshot of git://git.lysator.liu.se/${PN}/${PN}.git
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="l10n_sv"

S="${WORKDIR}/${PN}"
ELISP_PATCHES="${P}-no-git.patch"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	local d=${PV#*_p}
	sed -i "s/@@DATE@@/${d:0:4}-${d:4:2}-${d:6:2}/" src/Makefile || die
}

src_compile() {
	emake -C src EMACS=emacs
	# Info page is in Swedish only
	use l10n_sv && emake -C doc elisp-client
}

src_install() {
	elisp-install ${PN} src/lyskom.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc src/{ChangeLog*,README,TODO} doc/NEWS*
	use l10n_sv && doinfo doc/elisp-client

	DOC_CONTENTS="If you prefer an English language environment, add the
		following line to your ~/.emacs file:
		\n\t(setq-default kom-default-language 'en)"
	readme.gentoo_create_doc
}
