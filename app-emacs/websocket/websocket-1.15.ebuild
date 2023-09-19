# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A websocket implementation in elisp"
HOMEPAGE="https://github.com/ahyatt/emacs-websocket"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ahyatt/emacs-websocket.git"
	S="${WORKDIR}"/emacs-${P}
else
	[[ ${PV} == 1.15 ]] && COMMIT=40c208eaab99999d7c1e4bea883648da24c03be3

	SRC_URI="https://github.com/ahyatt/emacs-${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/emacs-${PN}-${COMMIT}

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

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
