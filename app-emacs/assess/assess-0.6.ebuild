# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Test support functions for Emacs"
HOMEPAGE="https://github.com/phillord/assess/"
SRC_URI="https://github.com/phillord/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/m-buffer"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/load-relative )
"

DOCS=( README.md )

# Remove a test helper accessing the network, luckily unnecessary
ELISP_REMOVE="test/local-sandbox.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test \
			 -l assess-discover -f assess-discover-run-and-exit-batch || die
}
