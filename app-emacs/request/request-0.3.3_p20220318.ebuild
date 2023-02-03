# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=c769cf33f2ac0a1a9798b508935c4b260e856ab5
NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Compatible layer for URL request"
HOMEPAGE="https://github.com/tkf/emacs-request/"
SRC_URI="https://github.com/tkf/emacs-${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"
RESTRICT="test"

RDEPEND="app-emacs/deferred"
BDEPEND="${RDEPEND}"

DOCS=( README.rst )
SITEFILE="50${PN}-gentoo.el"
