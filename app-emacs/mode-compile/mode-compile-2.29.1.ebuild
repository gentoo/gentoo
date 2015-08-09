# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Smart command for compiling files according to major-mode"
HOMEPAGE="https://github.com/emacsmirror/mode-compile
	http://www.emacswiki.org/emacs/ModeCompile"
SRC_URI="https://github.com/emacsmirror/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
