# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="Fish-style path truncation for GNU Emacs"
HOMEPAGE="https://gitlab.com/bennya/shrink-path.el/"
SRC_URI="https://gitlab.com/bennya/${PN}.el/-/archive/v${PV}/${PN}.el-v${PV}.tar.bz2"
S="${WORKDIR}"/${PN}.el-v${PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/s
	app-emacs/dash
	app-emacs/f
"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/buttercup )
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i 's|it "same as shrink-path"|xit "same as shrink-path"|' \
		"${S}"/test/shrink-path-test.el || die

	default
}

src_test() {
	buttercup -L . -L test --traceback full test || die
}
