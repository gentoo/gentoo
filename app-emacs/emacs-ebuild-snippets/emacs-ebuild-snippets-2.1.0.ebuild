# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Yasnippets for editing ebuilds and eclasses"
HOMEPAGE="https://gitweb.gentoo.org/proj/emacs-ebuild-snippets.git"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitweb.gentoo.org/proj/${PN}.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

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
