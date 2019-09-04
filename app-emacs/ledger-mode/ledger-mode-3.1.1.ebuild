# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Emacs major mode for editing ledger files"
HOMEPAGE="https://github.com/ledger/ledger-mode"
SRC_URI="https://github.com/ledger/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="doc/ledger-mode.texi"
BYTECOMPFLAGS+=" -l ledger-regex.el"

RDEPEND="!<app-office/ledger-3.1.2[emacs(-)]"
BDEPEND="sys-apps/texinfo"
