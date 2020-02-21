# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp readme.gentoo-r1

MY_P="${PN}.el-${PV}"
DESCRIPTION="An Emacs major mode for editing Python source"
HOMEPAGE="https://launchpad.net/python-mode"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"
DOCS="NEWS README_DEVEL.org"
DOC_CONTENTS="Note that doctest and pymacs are in their own packages,
	app-emacs/doctest-mode and app-emacs/pymacs, respectively."
