# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=f3a137628e112a91910fd33c0cff0948fa58d470
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Buffer interface library for Emacs"
HOMEPAGE="https://github.com/alezost/bui.el/"
SRC_URI="https://github.com/alezost/${PN}.el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="app-emacs/dash"
BDEPEND="${RDEPEND}"

DOCS=( NEWS README.org examples )
SITEFILE="50${PN}-gentoo.el"
