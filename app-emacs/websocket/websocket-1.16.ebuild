# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="A websocket implementation in elisp"
HOMEPAGE="https://github.com/ahyatt/emacs-websocket/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ahyatt/emacs-${PN}"
else
	SRC_URI="https://github.com/ahyatt/emacs-${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/emacs-${P}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
PROPERTIES="test_network"
RESTRICT="test"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}"

src_compile() {
	elisp-compile ${PN}.el
}

src_install() {
	elisp-install ${PN} websocket.{el,elc}
	elisp-make-site-file "${SITEFILE}"
	einstalldocs
}
