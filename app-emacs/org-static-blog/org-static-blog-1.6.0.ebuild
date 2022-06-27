# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Static site generator using Emacs's org-mode"
HOMEPAGE="https://github.com/bastibe/org-static-blog/"
SRC_URI="https://github.com/bastibe/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
