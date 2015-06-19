# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mode-compile/mode-compile-2.29.1.ebuild,v 1.1 2014/02/20 17:36:48 ulm Exp $

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
