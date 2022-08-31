# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=2aae2fbd4971dff965c758ec19688780ed7bff21
NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Emacs major mode for ReScript"
HOMEPAGE="https://github.com/jjlee/rescript-mode/"
SRC_URI="https://github.com/jjlee/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/ert-runner )"

DOCS=( README.md error.png typeinfo.png )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}
