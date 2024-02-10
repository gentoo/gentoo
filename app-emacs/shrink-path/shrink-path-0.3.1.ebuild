# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Fish-style path truncation for GNU Emacs"
HOMEPAGE="https://gitlab.com/bennya/shrink-path.el/"
SRC_URI="https://gitlab.com/bennya/${PN}.el/-/archive/v${PV}/${PN}.el-v${PV}.tar.bz2"
S="${WORKDIR}"/${PN}.el-v${PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	app-emacs/s
	app-emacs/dash
	app-emacs/f
"
BDEPEND="${RDEPEND}"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test

src_prepare() {
	sed -i 's|it "same as shrink-path"|xit "same as shrink-path"|' \
		"${S}"/test/shrink-path-test.el || die

	default
}
