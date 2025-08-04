# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="An Emacs major mode for editing Python source"
HOMEPAGE="https://gitlab.com/python-mode-devs/python-mode"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/python-mode-devs/${PN}"
else
	SRC_URI="https://gitlab.com/python-mode-devs/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="amd64 arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	python-mode-pkg.el
"

DOCS="CONTRIBUTING.md CREDITS NEWS *.org"
SITEFILE="50${PN}-gentoo.el"

DOC_CONTENTS="Note that doctest and pymacs are in their own packages,
	app-emacs/doctest-mode and app-emacs/pymacs, respectively."
