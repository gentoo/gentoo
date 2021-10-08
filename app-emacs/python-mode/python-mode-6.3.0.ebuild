# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="An Emacs major mode for editing Python source"
HOMEPAGE="https://gitlab.com/python-mode-devs/python-mode"
SRC_URI="https://gitlab.com/python-mode-devs/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

ELISP_REMOVE="python-mode-pkg.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="CONTRIBUTING.md CREDITS NEWS *.org"
DOC_CONTENTS="Note that doctest and pymacs are in their own packages,
	app-emacs/doctest-mode and app-emacs/pymacs, respectively."
