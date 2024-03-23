# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs client for Mastodon, federated microblogging social network"
HOMEPAGE="https://codeberg.org/martianh/mastodon.el/"
SRC_URI="https://codeberg.org/martianh/${PN}.el/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}.el/lisp"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/persist
	app-emacs/request
"
BDEPEND="${RDEPEND}"

DOCS=( ../README.org )
ELISP_TEXINFO="../${PN}.texi"
SITEFILE="50${PN}-gentoo.el"
