# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Algol68 major mode for GNU Emacs"
HOMEPAGE="https://elpa.gnu.org/packages/a68-mode.html
	https://git.sr.ht/~jemarch/a68-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~jemarch/${PN}"
else
	[[ "${PV}" == *p20260615 ]] && COMMIT=74896db77db4ce68e0022bceb3e7c73be452086c

	SRC_URI="https://git.sr.ht/~jemarch/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.srht.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
