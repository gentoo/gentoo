# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit readme.gentoo-r1 elisp

DESCRIPTION="Undo trees and visualization"
HOMEPAGE="http://www.dr-qubit.org/undo-tree.html"
SRC_URI="https://gitlab.com/tsc25/${PN}/-/archive/release/${PV}/${PN}-release-${PV}.tar.gz"
S="${WORKDIR}"/${PN}-release-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-emacs/queue"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To enable undo trees globally, place '(global-undo-tree-mode)'
	in your .emacs file."
