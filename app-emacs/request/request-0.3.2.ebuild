# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Compatible layer for URL request"
HOMEPAGE="https://github.com/tkf/emacs-request/"
SRC_URI="https://github.com/tkf/emacs-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"
RESTRICT="test"

RDEPEND="app-emacs/deferred"
BDEPEND="${RDEPEND}"

DOCS=( README.rst )
SITEFILE="50${PN}-gentoo.el"
