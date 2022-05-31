# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="List Oriented Buffer Operations for Emacs"
HOMEPAGE="https://github.com/phillord/m-buffer-el/"
SRC_URI="https://github.com/phillord/${PN}-el/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-el-${PV}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/load-relative )"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test \
		-l dev/assess-discover -f assess-discover-run-and-exit-batch || die
}
