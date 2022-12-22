# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Manage your installed packages with Emacs"
HOMEPAGE="https://gitlab.com/jabranham/system-packages/"
SRC_URI="https://gitlab.com/jabranham/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( README.org )
ELISP_REMOVE=".dir-locals.el"
SITEFILE="50${PN}-gentoo.el"
