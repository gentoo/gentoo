# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="X protocol Emacs Lisp Binding"
HOMEPAGE="https://github.com/emacs-exwm/xelb/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-exwm/${PN}.git"
else
	SRC_URI="https://github.com/emacs-exwm/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-editors/emacs[gui]
	x11-apps/xauth
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
