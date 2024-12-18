# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="emacs-${PN}"

inherit elisp

DESCRIPTION="HTML-ize font-lock buffers in Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/Htmlize
	https://github.com/hniksic/emacs-htmlize"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hniksic/${REAL_PN}.git"
else
	SRC_URI="https://github.com/hniksic/${REAL_PN}/archive/release/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${REAL_PN}-release-${PV}"

	KEYWORDS="amd64 ppc x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md NEWS )
SITEFILE="50${PN}-gentoo.el"
