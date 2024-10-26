# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Helper functions for Fediverse or other REST API clients for GNU Emacs"
HOMEPAGE="https://codeberg.org/martianh/fedi.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://codeberg.org/martianh/${PN}.el.git"
else
	SRC_URI="https://codeberg.org/martianh/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/markdown-mode
	|| (
		>=app-editors/emacs-31.0
		>=app-editors/emacs-${NEED_EMACS}[json]
	)
"
BDEPEND="
	${RDEPEND}
"

DOCS=( readme.org )
SITEFILE="50${PN}-gentoo.el"
