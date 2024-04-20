# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_PN="${PN}-el"
DESCRIPTION="Emacs package for talking to a dictionary server"
HOMEPAGE="https://www.myrkr.in-berlin.de/dictionary/index.html"
SRC_URI="https://github.com/myrkr/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

ELISP_REMOVE="install-package.el lpath.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README"
