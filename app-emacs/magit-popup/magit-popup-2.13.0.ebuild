# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="Define prefix-infix-suffix command combos"
HOMEPAGE="https://magit.vc/manual/magit-popup"
SRC_URI="https://github.com/magit/magit-popup/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="*.texi"
DOCS="README.md"

CDEPEND=">=app-emacs/dash-2.13.0"
DEPEND="${CDEPEND} sys-apps/texinfo"
RDEPEND="!!<app-emacs/magit-2.12.1
	${CDEPEND}"
