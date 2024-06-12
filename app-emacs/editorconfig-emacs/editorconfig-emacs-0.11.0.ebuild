# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="EditorConfig plugin for emacs"
HOMEPAGE="https://github.com/editorconfig/editorconfig-emacs"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/editorconfig/${PN}.git"
else
	SRC_URI="https://github.com/editorconfig/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
DOCS=( CHANGELOG.md README.md )
DOC_CONTENTS="The EditorConfig feature is not enabled as a site default.
	Add the following line to your ~/.emacs file to activate it:
	\n\t(editorconfig-mode 1)"

elisp-enable-tests ert ./ert-tests -l ./ert-tests/editorconfig-core.el
