# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature readme.gentoo-r1

DESCRIPTION="Emacs speech support"
HOMEPAGE="https://www.freebsoft.org/speechd-el/
	https://github.com/brailcom/speechd-el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/brailcom/${PN}"
else
	SRC_URI="https://github.com/brailcom/${PN}/archive/refs/tags/${P}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${P}"

	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-accessibility/speech-dispatcher-0.7
"

DISABLE_AUTOFORMATTING="YES"
DOC_CONTENTS="To get Emacs to speak execute:
M-x speechd-speak RET

or add following to your initialization file (~/.emacs):
(speechd-speak)"

DOCS=( ANNOUNCE NEWS README speechd-speak.pdf )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake EMACS="${EMACS}"
}

src_install() {
	elisp_src_install
	dobin speechd-log-extractor
	doinfo "${PN}.info"
}

pkg_postinst() {
	elisp_pkg_postinst
	optfeature "braille support" "app-accessibility/brltty"
}
