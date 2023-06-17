# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Marginalia in the minibuffer"
HOMEPAGE="https://github.com/minad/marginalia"
SRC_URI="https://github.com/minad/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
