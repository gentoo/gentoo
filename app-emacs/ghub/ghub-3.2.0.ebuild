# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=25

inherit elisp

DESCRIPTION="Minuscule client library for the Git forge APIs"
HOMEPAGE="https://magit.vc/manual/ghub"
SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="*.texi"
DOCS="README.md"

RDEPEND="
	>=app-emacs/dash-2.14.1
	>=app-emacs/graphql-0.1.1
	>=app-emacs/treepy-0.0.1
"
BDEPEND="${RDEPEND}
	sys-apps/texinfo"
