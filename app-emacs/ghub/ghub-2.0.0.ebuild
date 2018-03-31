# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
NEED_EMACS=24

inherit elisp

DESCRIPTION="minuscule client library for the Github API"
HOMEPAGE="https://magit.vc/manual/ghub"
SRC_URI="https://github.com/magit/ghub/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="*.texi"
DOCS="README.md"

DEPEND="sys-apps/texinfo"
