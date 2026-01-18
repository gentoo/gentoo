# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Emacs client for Mastodon, federated microblogging social network"
HOMEPAGE="https://codeberg.org/martianh/mastodon.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://codeberg.org/martianh/${PN}.el"
	S="${WORKDIR}/${P}/lisp"
else
	SRC_URI="https://codeberg.org/martianh/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el/lisp"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/persist
	app-emacs/request
	app-emacs/tp
"
BDEPEND="
	${RDEPEND}
"

DOCS=( ../README.org )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	doinfo "../${PN}.info"
}
