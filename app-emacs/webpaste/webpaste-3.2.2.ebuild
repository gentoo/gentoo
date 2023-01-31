# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Paste parts of buffers to several pastebin-like services from Emacs"
HOMEPAGE="https://github.com/etu/webpaste.el/"
SRC_URI="https://github.com/etu/${PN}.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/request"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/buttercup )
"

DOCS=( README.org )
# Remove failing tests
ELISP_REMOVE="tests/unit/test-webpaste-provider-creation.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L tests tests/unit || die
}
