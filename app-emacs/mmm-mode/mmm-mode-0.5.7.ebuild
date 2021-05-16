# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Enables the user to edit different parts of a file in different major modes"
HOMEPAGE="http://mmm-mode.sourceforge.net/"
SRC_URI="https://github.com/purcell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="sys-apps/texinfo"

PATCHES=("${FILESDIR}"/${P}-texinfo-encoding.patch)
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="mmm.texinfo"
DOCS="AUTHORS FAQ NEWS README README.Mason TODO"
