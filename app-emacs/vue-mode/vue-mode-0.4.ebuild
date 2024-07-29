# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major Emacs mode for vue component based on mmm-mode"
HOMEPAGE="https://github.com/AdamNiederer/vue-mode/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AdamNiederer/${PN}.git"
else
	SRC_URI="https://github.com/AdamNiederer/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/edit-indirect
	app-emacs/mmm-mode
	app-emacs/ssass-mode
	app-emacs/vue-html-mode
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/undercover
		app-emacs/s
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
