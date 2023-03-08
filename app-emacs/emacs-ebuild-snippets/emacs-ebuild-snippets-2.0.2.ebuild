# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="Yasnippets for editing ebuilds and eclasses"
HOMEPAGE="https://gitweb.gentoo.org/proj/emacs-ebuild-snippets.git"
SRC_URI="https://gitlab.com/xgqt/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/ebuild-mode
	app-emacs/yasnippet
"
BDEPEND="${RDEPEND}"

src_prepare() {
	sh ./scripts/changeme.sh "${EPREFIX}${SITEETC}/${PN}" || die

	default
}

src_install() {
	elisp-install ${PN} *.el{,c}
	elisp-site-file-install "${S}"/gentoo/50${PN}-gentoo.el

	insinto "${SITEETC}/${PN}"
	doins -r snippets
}
