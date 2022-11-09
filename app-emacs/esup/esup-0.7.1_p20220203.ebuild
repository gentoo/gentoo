# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=4b49c8d599d4cc0fbf994e9e54a9c78e5ab62a5f
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Benchmark Emacs Startup time without ever leaving it"
HOMEPAGE="https://github.com/jschaf/esup/"
SRC_URI="https://github.com/jschaf/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/s"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/buttercup
		app-emacs/dash
		app-emacs/noflet
		app-emacs/undercover
	)
"

DOCS=( README.md esup-screenshot.png )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L test --traceback full test || die
}
